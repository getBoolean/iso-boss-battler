extends Node

const SUCCESS_CODE = 0
const PLAYER_IDLE = 'Idle'
const PLAYER_RUN = 'Run'
const PLAYER_DEATH = 'Death'

enum AudioTracks { MASTER, MUSIC, SFX }

# triggers after the first time the player has died in level1.
# put it outside of the level scene so that it doesn't get reset
# when the level is reloaded
var player_died_level1 = false

func update_volume(index, volume):
    AudioServer.set_bus_volume_db(index, volume)
