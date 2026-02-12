extends Node

# Generic event bus so make signal using easier.
# ex. signal on_game_start()

signal on_enemy_damage(enemy: Enemy, source: Node2D)
