require_relative '../data/lairs_data'
require_relative 'encounters'
require_relative '../data/xp_difficulty_table'

class Lairs
  include LairsData
  include XpDifficultyTable
  AVAILABLE_ENCOUNTER_LEVEL = REVERSED_XP_DIFFICULTY_TABLE.keys

  MIN_PARTY_LEVEL_MUL = 0.4

  attr_reader :lair_type

  # encounter_level : :easy, :medium, :hard, :deadly
  def initialize( encounter_level, hero_levels, lair_type = nil)

    @encounters = Encounters.new
    @encounter_level = encounter_level
    @hero_levels = hero_levels
    check_params

    @party_xp_level = hero_levels.map{ |hl| XP_DIFFICULTY_TABLE[hl][@encounter_level] }.reduce(&:+)

    @lair_type = lair_type ? lair_type : get_available_lairs.sample
  end

  def encounter
    encounter_id = get_available_encounters.sample
    @encounters.by_id encounter_id
  end

  def to_hash
    { encounter_level: @encounter_level, hero_levels: @hero_levels, lair_type: @lair_type }
  end

  def self.from_hash( hash )
    hash = hash.map { |k, v| [k.to_sym, v] }.to_h
    Lairs.new( hash[ :encounter_level ].to_sym, hash[ :hero_levels ], hash[ :lair_type ].to_sym )
  end

  private

  def get_available_lairs
    LAIRS_DATA[:by_xp_lair].select{ |k, _| k >= @party_xp_level*MIN_PARTY_LEVEL_MUL && k <= @party_xp_level }.values.flatten.uniq
  end

  def get_available_encounters
    LAIRS_DATA[:lairs][@lair_type][:by_encounters_xp].select{ |k, _| k >= @party_xp_level*MIN_PARTY_LEVEL_MUL && k <= @party_xp_level }.values.flatten.uniq
  end

  def check_params
    raise 'Empty party is not valid. Please provide at least one hero' if @hero_levels.empty?

    raise "Bad encounter level : #{@encounter_level.inspect}. Available encounter level : #{AVAILABLE_ENCOUNTER_LEVEL.inspect}" unless AVAILABLE_ENCOUNTER_LEVEL.include?( @encounter_level )
    raise 'Party too weak. Minimum 3 members' if @hero_levels.count < 3

    @hero_levels.each do |level|
      raise "Hero level should be an integer currently : #{level.class.to_s}" unless level.class == Integer
      raise "Bad hero level : #{level}. Should be between 1 .. 20" if level < 1 || level > 20
    end
  end

end