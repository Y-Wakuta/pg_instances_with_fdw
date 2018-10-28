CREATE TABLE actor_plays(
    AID integer references Actor(AID),
    MID integer references Movie(MID)
);
