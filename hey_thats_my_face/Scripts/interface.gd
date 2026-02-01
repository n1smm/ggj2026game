extends HBoxContainer

# L'array che hai già popolato nell'Inspector
@export var icone_slot_1: Array[Texture2D] 

# Variabile booleana per lo stato di default
var in_sequenza: bool = false

func _ready():
	# All'inizio mostriamo l'immagine 0
	aggiorna_immagine(0)

# Questa funzione serve solo a cambiare la texture del primo figlio
func aggiorna_immagine(indice: int):
	var slot_1 = get_child(0)
	if indice < icone_slot_1.size():
		slot_1.texture = icone_slot_1[indice]

# Questa è la funzione che devi chiamare per far partire tutto!
func avvia_sequenza_timer():
	if in_sequenza: return # Evita che la sequenza riparta se è già in corso
	
	in_sequenza = true
	print("Sequenza iniziata - Immagine 0 per 7 secondi")
	
	# 1. Mostra immagine 1 per 7 secondi
	aggiorna_immagine(1)
	await get_tree().create_timer(7.0).timeout
	
	# 2. Mostra immagine 1 (ancora la 1?) per 3 secondi 
	# (Nota: se è la stessa immagine, non vedrai cambiamenti finché non passano i 3 secondi)
	print("Prossimo step - Immagine 1 per 3 secondi")
	aggiorna_immagine(1)
	await get_tree().create_timer(3.0).timeout
	
	# 3. Mostra immagine 2 per 2 secondi
	print("Prossimo step - Immagine 2 per 2 secondi")
	aggiorna_immagine(2)
	await get_tree().create_timer(2.0).timeout
	
	# 4. Mostra immagine 3 per 1 secondo
	print("Prossimo step - Immagine 3 per 1 secondo")
	aggiorna_immagine(3)
	await get_tree().create_timer(1.0).timeout
	
	# 5. Mostra immagine 5 per 1 secondo
	# ATTENZIONE: Assicurati di avere almeno 6 immagini nell'array (0,1,2,3,4,5)
	print("Prossimo step - Immagine 5 per 1 secondo")
	aggiorna_immagine(5)
	await get_tree().create_timer(1.0).timeout
	
	# FINE: Torna alla 0 e resetta la bool
	print("Sequenza finita - Torna a immagine 0")
	aggiorna_immagine(0)
	in_sequenza = false

# ESEMPIO: Se vuoi far partire la sequenza premendo un tasto (es. Spazio)
func _input(event):
	if event.is_action_pressed("ui_accept"): # "ui_accept" è solitamente Invio o Spazio
		avvia_sequenza_timer()
