# Script to invoke HTTP server using Flask which provides get operation to the user to query the Rocksdb database
# @author Sahil Sharma
# @group Mini project - CS 532- Group 13.

import flask
import rocksdb
import sys

# Taking the db name as argument from the user to load it, otherwise setting it to invertedPairs.db by default
try:
    sys.argv[1]
except IndexError:
    db_name = "invertedPairs.db"
else:
    db_name = str(sys.argv[1])

try: 
    db = rocksdb.DB(db_name, rocksdb.Options(create_if_missing=True))
except:
    print("Unexpected error:", sys.exc_info()[0])
    raise

# initialising flask app
app = flask.Flask(__name__)

# Get method implementation to query the rocksdb
@app.route("/search", methods=["GET"])
def search():
    try:
        query = flask.request.args.get('query')
        keys = query.lower().split()
        values = []
        for key in keys:
            values += db.get(key.encode()).decode().split(', ')
    except AttributeError:
        return flask.jsonify()
    except:
        return flask.jsonify()
        raise
    # send unique values as JSON response
    return flask.jsonify(list(set(values)))


if __name__ == "__main__":
    try:
        print(("Flask starting server..."
            "please wait until server has fully started"))
	# running the server on localhost port 5900 : localhost:5900/search?query=<list of queries>
        app.run(host ='0.0.0.0',port=5900)
    except KeyboardInterrupt:
        print("Closing the connection.")
        #app.stop()
        raise
    except:
        print("Unexpected error:", sys.exc_info()[0])
        raise
    finally:
	# making sure rocksdb is gracefully closed
        db.close()

