extends HBoxContainer

# L'array che hai già popolato nell'Inspector
@export var icone_slot_1: Array[Texture2D] 

# Variabile booleana per lo stato di default
var in_sequenza: bool = false

func _ready():
	# All'inizio mostriamo l'immagine 0
	aggiorna_immagine(0)
	if GameManager:
		GameManager.mask_progress_changed.connect(_on_mask_progress_change)

func _on_mask_progress_change(progress: int) -> void:
	aggiorna_immagine(progress)

# Questa funzione serve solo a cambiare la texture del primo figlio
func aggiorna_immagine(indice: int):
	var slot_1 = get_child(0)
	if indice < icone_slot_1.size():
		slot_1.texture = icone_slot_1[indice]

