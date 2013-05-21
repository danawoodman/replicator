# Replicator

Rails application generator used at [Teleporter](http://teleporter.io).

## Usage

To create a new Rails application using Replicator, run the following on your command line:

```bash
rails new myapp -m https://github.com/teleporter/replicator/blob/master/replicator.rb -T
```

If you're using MongoDB, then make sure to pass in the `-O` option:

```bash
rails new myapp -m https://github.com/teleporter/replicator/blob/master/replicator.rb -T -O
```
