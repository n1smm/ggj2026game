extends HBoxContainer

# L'array che hai già popolato nell'Inspector
@export var icone_slot_1: Array[Texture2D] 

# Variabile booleana per lo stato di default
var in_sequenza: bool = false

func _ready():
	# All'inizio mostriamo l'immagine 0
	aggiorna_immagine(0)
	aggiorna_arma(0)
	if GameManager:
		GameManager.mask_progress_changed.connect(_on_mask_progress_change)
		GameManager.scalpel_durability_change.connect(_on_weapon_durability_change)

func _on_mask_progress_change(progress: int) -> void:
	if progress == -1:
		progress = 0
	else:
		progress += 1
	aggiorna_immagine(progress)

func _on_weapon_durability_change(progress: int):
	aggiorna_arma(progress)

# Questa funzione serve solo a cambiare la texture del primo figlio
func aggiorna_immagine(indice: int):
	var slot_1 = get_child(0)
	if indice < icone_slot_1.size():
		slot_1.texture = icone_slot_1[indice]
<<<<<<< HEAD
=======

func aggiorna_arma(durability: int):
	var slot = get_child(1)
	if durability > 0:
		slot.modulate.a = 1.0
	else:
		slot.modulate.a = 0.15

>>>>>>> a078d7bbe0cb1823c69e79e610ba7a8343a37522
