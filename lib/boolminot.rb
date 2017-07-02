require 'boolminot/version'

require 'logica'

require 'boolminot/helpers/range_bounds_validator'

require 'boolminot/clauses/base'
require 'boolminot/clauses/generic'
require 'boolminot/clauses/terms'
require 'boolminot/clauses/range'
require 'boolminot/clauses/nested'

require 'boolminot/clauses/negation'
require 'boolminot/clauses/match_all'
require 'boolminot/clauses/match_none'

require 'boolminot/clauses/compounds/base'
require 'boolminot/clauses/compounds/conjunction'
require 'boolminot/clauses/compounds/disjunction'
require 'boolminot/clauses/compounds/at_least'

require 'boolminot/clause_factory'

module Boolminot
  def self.clause_factory
    @clause_factory ||= ClauseFactory.new
  end
end
