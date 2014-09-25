#encoding: utf-8

from flask import Flask, request
import redis

app = Flask(__name__)
redis = redis.StrictRedis()


@app.route('/counter', methods=['GET', 'POST'])
def get_or_incr():
    name = 'counter'
    post_key = 'incrBy'

    if request.method == 'POST' and post_key in request.form:
        redis.incr(name, request.form[post_key])
    return redis.get(name) or '0'


if __name__ == '__main__':
    app.run(port=8080)
