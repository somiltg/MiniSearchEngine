import org.apache.spark.{SparkConf, SparkContext}

/**
 * Spark application to invert indexes for a document set.
 *
 * @author somilgupta
 * @group Mini project - CS 532- Group 13.
 */
object IndexInverter {

  /**
   * Apply parsing logic to the document. <\p>
   *   Logic: Word can either be a number (with $, comma and decimal)- ended by a comma, or it can be a word that
   *   can be ended by an apostrophe. Copy to https://regexr.com/ to break down the regex.
   *
   * @param content Content of the document.
   * @return Words list.
   */
  def parseDocumentIntoWordsList(content: String): Iterator[String] = {
    """(\$(?:[0-9]+[,.]?[0-9]+)+|\w+'?\w*)""".r.findAllIn(content).map(_.toLowerCase)
  }

  /**
   * Main function.
   *
   * @param args Arg 0: Project location.
   */
  def main(args: Array[String]) {
    // create Spark context with Spark configuration
    val sc = new SparkContext(new SparkConf().setAppName("Index Inverter"))
    val projectLocation = args(0)
    val output_fn = s"$projectLocation/invertedIndexOutput/output"
    // Preprocessing
    val documentIdToWordLists = sc.wholeTextFiles(s"$projectLocation/Project1_data")
                          .map(tuple => "(doc_[0-9]+)".r.findFirstIn(tuple._1).get -> parseDocumentIntoWordsList(tuple._2))
                          .persist()

    val idToLinks = sc.textFile(s"$projectLocation/id_URL_pairs.txt")
                          .flatMap(_.split("\n")).map(_.split(","))
                          .map(a => a(0) -> a(1))
                          .persist()

    //Invert indices
    val invertedIndex = documentIdToWordLists
                          .flatMap(tuple => tuple._2.map(word=> word->tuple._1))
                          .distinct()
                          .groupByKey().sortByKey(ascending = true)
                          .persist()

    //Replace docIds with url links
    val idToLinksMap = idToLinks.collectAsMap()
    val finalInvert = invertedIndex.mapValues(_.map(idToLinksMap(_)))

    //Store the final invert in hdfs to be taken up by the rocks db script.
    finalInvert.saveAsTextFile(output_fn)
    println("Written output in HDFS at location: "+ output_fn)
  }
}
