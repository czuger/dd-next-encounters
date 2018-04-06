[![Build Status](https://travis-ci.org/czuger/dd-next-encounters.svg?branch=master)](https://travis-ci.org/czuger/dd-next-encounters)
[![Maintainability](https://api.codeclimate.com/v1/badges/86fce10ff4955054dd4c/maintainability)](https://codeclimate.com/github/czuger/dd-next-encounters/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/86fce10ff4955054dd4c/test_coverage)](https://codeclimate.com/github/czuger/dd-next-encounters/test_coverage)

# dd-next-encounters
An encounter generator for DD next

# Compatibility

Require ruby 2.4.0 or higher.

# Setup

```shell
gem install dd-next-encounters
```

Or in your gemfile : 
```ruby
gem 'dd-next-encounters'
```

Then in your code :
```ruby
require 'dd-next-encounters'
```

# Usage

```ruby
# Create a lair object for a four five level party at medium difficulty.
# Difficulty can be :easy, :medium, :hard, :deadly
# Note that level 15 is the max for now
l = Lairs.new :medium, [5]*4

# Then you can generate encounters for this lair.
1.upto(5).each do
  p l.encounter.to_s
end

# Output example : 
# "6 Hobgoblin"
# "3 Bugbear"
# "4 Orc"
# "5 Gnoll"
# "6 Gnoll"
```