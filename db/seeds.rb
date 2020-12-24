pokemon_id = SecureRandom.uuid # => "015f6705-c21f-403f-9a30-ff51b0254ac4"
stream_name = "Pokemon$#{pokemon_id}" # => "Pokemon$015f6705-c21f-403f-9a30-ff51b0254ac4"
repository = AggregateRoot::Repository.new
# => #<AggregateRoot::Repository:0x00007f83db445ca8 @event_store=#<RailsEventStore::Client:0x4498>>

pokemon = repository.load(Aggregates::Pokemon.new(pokemon_id), stream_name)
# RailsEventStoreActiveRecord::EventInStream Load (17.3ms)
#   SELECT "event_store_events_in_streams".* FROM "event_store_events_in_streams"
#   WHERE "event_store_events_in_streams"."stream" = $1
#   ORDER BY "event_store_events_in_streams"."position" ASC, "event_store_events_in_streams"."id" ASC LIMIT $2
#   [["stream", "Pokemon$015f6705-c21f-403f-9a30-ff51b0254ac4"], ["LIMIT", 100]]
# => #<Aggregates::Pokemon:0x00007f83dae95d30
#       @status=:new, @id="015f6705-c21f-403f-9a30-ff51b0254ac4",
#       @attributes=nil, @version=-1, @unpublished_events=[]>

pokemon.appear_on_the_wild(pokemon_id: pokemon_id, route: '11')
# => [
#   #<Events::Pokemons::WildPokemonAppeared:0x00007f83d7402510
#       @event_id="4939eebf-145c-4f53-9439-054bac749b85",
#       @metadata=#<RubyEventStore::Metadata:0x00007f83d7401e80 @h={}>,
#       @data={
#         :pokemon_id=>"015f6705-c21f-403f-9a30-ff51b0254ac4",
#         :route=>"11", :attributes=>{
#           :gender=>nil, :level=>10, :attack=>99, :defense=>24,
#           :speed=>63, :experience=>0
#         }
#       }
#   >
# ]

repository.store(pokemon, stream_name)
# TRANSACTION (0.2ms)  BEGIN

# RailsEventStoreActiveRecord::Event Create Many (7.5ms) 
#   INSERT INTO "event_store_events" ("id","data","metadata","event_type","created_at")
#   VALUES ('4939eebf-145c-4f53-9439-054bac749b85',
#     '\x2d2d2d0a3a706f6b656d6f6e5f69643a2030313566363730352d633231662d343033662d396133302d6666353162303235346163340a3a726f7574653a20273131270a3a617474726962757465733a0a20203a67656e6465723a200a20203a6c6576656c3a2031300a20203a61747461636b3a2039390a20203a646566656e73653a2032340a20203a73706565643a2036330a20203a657870657269656e63653a20300a','\x2d2d2d0a3a74696d657374616d703a20323032302d31322d32332031373a31343a34322e343738363037303030205a0a3a636f7272656c6174696f6e5f69643a2031343665613630332d633461312d343931312d393932652d3330646265323833306134380a',
#     'Events::Pokemons::WildPokemonAppeared','2020-12-23 17:14:42.500855')
#   RETURNING "id"

# RailsEventStoreActiveRecord::EventInStream Create Many (1.2ms)
#   INSERT INTO "event_store_events_in_streams" ("stream","position","event_id","created_at")
#   VALUES ('Pokemon$015f6705-c21f-403f-9a30-ff51b0254ac4',0,
#     '4939eebf-145c-4f53-9439-054bac749b85','2020-12-23 17:14:42.512806'),
#     ('all',NULL,'4939eebf-145c-4f53-9439-054bac749b85','2020-12-23 17:14:42.512806')
#   RETURNING "id"

# TRANSACTION (7.9ms)  COMMIT
# => 0

event = Rails.configuration.event_store.read.stream(stream_name).last
# event = Rails.configuration.event_store.read.event "1da45bfa-d0a2-486b-8b78-cda1b2550513"
###

# RailsEventStoreActiveRecord::EventInStream Load (0.4ms)
#   SELECT "event_store_events_in_streams".* FROM "event_store_events_in_streams"
#   WHERE "event_store_events_in_streams"."stream" = $1
#   ORDER BY "event_store_events_in_streams"."position" DESC, "event_store_events_in_streams"."id" DESC LIMIT $2
#   [["stream", "Pokemon$015f6705-c21f-403f-9a30-ff51b0254ac4"], ["LIMIT", 1]]

# RailsEventStoreActiveRecord::Event Load (0.2ms)
#   SELECT "event_store_events".* FROM "event_store_events"
#   WHERE "event_store_events"."id" = $1  [["id", "4939eebf-145c-4f53-9439-054bac749b85"]]

# => #<Events::Pokemons::WildPokemonAppeared:0x00007f83dae26430
#   @event_id="4939eebf-145c-4f53-9439-054bac749b85",
#   @metadata=#<RubyEventStore::Metadata:0x00007f83dae26408 @h={
#     :timestamp=>2020-12-23 17:14:42.478607 UTC,
#     :correlation_id=>"146ea603-c4a1-4911-992e-30dbe2830a48"
#   }>,
#   @data={
#     :pokemon_id=>"015f6705-c21f-403f-9a30-ff51b0254ac4", :route=>"11",
#     :attributes=>{
#       :gender=>nil, :level=>10, :attack=>99,
#       :defense=>24, :speed=>63, :experience=>0
#     }
#   }
# >
