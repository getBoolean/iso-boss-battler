extends Node

const SUCCESS_CODE = 0
const PLAYER_IDLE = 'Idle'
const PLAYER_RUN = 'Run'
const PLAYER_DEATH = 'Death'

enum AudioTracks { MASTER, MUSIC, SFX }

func update_volume(index, volume):
    AudioServer.set_bus_volume_db(index, volume)
    
