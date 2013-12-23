# AntTsp

    Ants to solve travelling salesman

## Installation

Add this line to your application's Gemfile:

    gem 'ant_tsp'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ant_tsp

## Usage

    AntTsp::AntTsp.new.search([[565,575],[25,185]], 50, 30, 0.6, 2.5, 1.0)
    50 - max iterations
    30 - number of ants
    0.6 - pheromone decay
    2.5 - c heuristic
    1.0 - c history

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
