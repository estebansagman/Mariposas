import json
import os
import tkinter as tk
from tkinter import filedialog, messagebox, ttk

# --- LOGICA DE DATOS ---
class EditorDatos:
    def __init__(self):
        self.datos = {}
        self.archivo_actual = None

    def cargar_json(self, ruta):
        with open(ruta, 'r', encoding='utf-8') as f:
            self.datos = json.load(f)
        self.archivo_actual = ruta
        self.normalizar_estructuras()

    def cerrar_json(self):
        self.datos = {}
        self.archivo_actual = None

    def guardar_json(self, ruta=None):
        destino = ruta or self.archivo_actual
        if not destino:
            return False
        with open(destino, 'w', encoding='utf-8') as f:
            json.dump(self.datos, f, indent=4, ensure_ascii=False)
        if ruta:
            self.archivo_actual = ruta
        return True

    def normalizar_estructuras(self):
        categorias_a_normalizar = ["mariposas", "plantas"]
        for cat in categorias_a_normalizar:
            if cat not in self.datos or not isinstance(self.datos[cat], dict):
                continue
                
            estructura_maestra = {}
            for item_id, item_data in self.datos[cat].items():
                if isinstance(item_data, dict):
                    for campo, valor in item_data.items():
                        if campo not in estructura_maestra:
                            if isinstance(valor, list): estructura_maestra[campo] = []
                            elif isinstance(valor, dict): estructura_maestra[campo] = {}
                            elif isinstance(valor, float): estructura_maestra[campo] = 0.0
                            elif isinstance(valor, int): estructura_maestra[campo] = 0
                            else: estructura_maestra[campo] = ""

            for item_id, item_data in self.datos[cat].items():
                if isinstance(item_data, dict):
                    for campo, valor_defecto in estructura_maestra.items():
                        if campo not in item_data:
                            if isinstance(valor_defecto, list): item_data[campo] = list(valor_defecto)
                            elif isinstance(valor_defecto, dict): item_data[campo] = dict(valor_defecto)
                            else: item_data[campo] = valor_defecto

# --- INTERFAZ GRAFICA ---
class AppEditor(tk.Tk):
    def __init__(self, editor):
        super().__init__()
        self.editor = editor
        self.title("Editor MariposARG - Full Tools Edition")
        self.geometry("1200x750")
        
        self.nodo_seleccionado = None
        self.entradas_dinamicas = {}

        self.configurar_interfaz()

    def configurar_interfaz(self):
        panel_superior = ttk.Frame(self, padding=5)
        panel_superior.pack(side=tk.TOP, fill=tk.X)
        
        ttk.Button(panel_superior, text="Cargar JSON", command=self.cargar_archivo).pack(side=tk.LEFT, padx=5)
        ttk.Button(panel_superior, text="Guardar", command=self.guardar_archivo).pack(side=tk.LEFT, padx=5)
        ttk.Button(panel_superior, text="Guardar Como...", command=self.guardar_como_archivo).pack(side=tk.LEFT, padx=5)
        ttk.Button(panel_superior, text="Cerrar JSON", command=self.cerrar_archivo).pack(side=tk.LEFT, padx=5)
        
        self.lbl_archivo = ttk.Label(panel_superior, text="Ningún archivo cargado", font=("Arial", 9, "italic"))
        self.lbl_archivo.pack(side=tk.LEFT, padx=10)

        panel_principal = ttk.PanedWindow(self, orient=tk.HORIZONTAL)
        panel_principal.pack(fill=tk.BOTH, expand=True, padx=5, pady=5)

        # Panel Izquierdo
        panel_izquierdo = ttk.Frame(panel_principal)
        self.arbol = ttk.Treeview(panel_izquierdo, show="tree")
        self.arbol.pack(fill=tk.BOTH, expand=True, side=tk.TOP)
        self.arbol.bind("<<TreeviewSelect>>", self.al_seleccionar_nodo)
        
        panel_botones_crud = ttk.Frame(panel_izquierdo, padding=3)
        panel_botones_crud.pack(side=tk.BOTTOM, fill=tk.X)
        
        ttk.Button(panel_botones_crud, text="+ Clonar", command=self.agregar_item).pack(side=tk.LEFT, expand=True, fill=tk.X, padx=1)
        ttk.Button(panel_botones_crud, text="✎ Renombrar", command=self.renombrar_item).pack(side=tk.LEFT, expand=True, fill=tk.X, padx=1)
        ttk.Button(panel_botones_crud, text="- Eliminar", command=self.eliminar_item).pack(side=tk.LEFT, expand=True, fill=tk.X, padx=1)

        panel_principal.add(panel_izquierdo, weight=1)

        # Panel Derecho
        panel_derecho_global = ttk.Frame(panel_principal)
        
        self.panel_gestion_campos = ttk.LabelFrame(panel_derecho_global, text="Estructura de Campos Globales", padding=5)
        self.panel_gestion_campos.pack(side=tk.TOP, fill=tk.X, pady=2, padx=5)
        
        ttk.Button(self.panel_gestion_campos, text="[+] Añadir Campo Nuevo", command=self.añadir_campo_estructural).pack(side=tk.LEFT, padx=5)
        ttk.Button(self.panel_gestion_campos, text="[-] Eliminar un Campo", command=self.eliminar_campo_estructural).pack(side=tk.LEFT, padx=5)
        
        contenedor_formulario = ttk.Frame(panel_derecho_global)
        contenedor_formulario.pack(side=tk.BOTTOM, fill=tk.BOTH, expand=True)
        
        canvas = tk.Canvas(contenedor_formulario, borderwidth=0, highlightthickness=0)
        scrollbar = ttk.Scrollbar(contenedor_formulario, orient="vertical", command=canvas.yview)
        
        self.panel_formulario = ttk.LabelFrame(canvas, text="Atributos del Ítem Seleccionado", padding=10)
        self.panel_formulario.bind("<Configure>", lambda e: canvas.configure(scrollregion=canvas.bbox("all")))
        
        canvas.create_window((0, 0), window=self.panel_formulario, anchor="nw")
        canvas.configure(yscrollcommand=scrollbar.set)
        
        canvas.pack(side="left", fill="both", expand=True)
        scrollbar.pack(side="right", fill="y")
        
        panel_principal.add(panel_derecho_global, weight=2)

    def cargar_archivo(self):
        self.editor.cerrar_json()
        ruta = filedialog.askopenfilename(filetypes=[("Archivos JSON", "*.json")])
        if ruta:
            try:
                self.editor.cargar_json(ruta)
                self.lbl_archivo.config(text=ruta)
                self.actualizar_arbol()
                messagebox.showinfo("Éxito", "¡JSON cargado por completo!")
            except Exception as e:
                messagebox.showerror("Error", f"Error al cargar: {e}")

    def cerrar_archivo(self):
        self.guardar_cambios_nodo_actual()
        self.editor.cerrar_json()
        self.lbl_archivo.config(text="Ningún archivo cargado")
        self.nodo_seleccionado = None
        for item in self.arbol.get_children(): self.arbol.delete(item)
        for widget in self.panel_formulario.winfo_children(): widget.destroy()
        self.entradas_dinamicas.clear()
        messagebox.showinfo("Cerrado", "Base de datos descargada de la memoria.")

    def guardar_archivo(self):
        self.guardar_cambios_nodo_actual()
        if self.editor.guardar_json():
            messagebox.showinfo("Guardado", "¡JSON guardado exitosamente!")

    def guardar_como_archivo(self):
        self.guardar_cambios_nodo_actual()
        ruta = filedialog.asksaveasfilename(defaultextension=".json", filetypes=[("Archivos JSON", "*.json")])
        if ruta:
            if self.editor.guardar_json(ruta):
                self.lbl_archivo.config(text=ruta)
                messagebox.showinfo("Guardado", "Copia guardada con éxito.")

    def actualizar_arbol(self, seleccionar_id=None):
        for item in self.arbol.get_children(): self.arbol.delete(item)
        d = self.editor.datos
        
        for cat in ["sectores", "plantas", "mariposas"]:
            if cat in d and isinstance(d[cat], dict):
                root_node = self.arbol.insert("", "end", iid=cat, text=cat.capitalize(), open=True)
                for k in d[cat].keys():
                    self.arbol.insert(root_node, "end", iid=f"{cat}/{k}", text=k)
        
        listas_orden = ["orden_inportancia_mariposas", "orden_planta"]
        tiene_listas = any(l in d for l in listas_orden)
        if tiene_listas:
            root_orden = self.arbol.insert("", "end", iid="listas_globales", text="Listas de Orden", open=True)
            for l in listas_orden:
                if l in d: self.arbol.insert(root_orden, "end", iid=f"orden/{l}", text=l)

        if seleccionar_id and self.arbol.exists(seleccionar_id):
            self.arbol.selection_set(seleccionar_id)

    def al_seleccionar_nodo(self, event):
        self.guardar_cambios_nodo_actual()
        seleccion = self.arbol.selection()
        if not seleccion: return
        
        self.nodo_seleccionado = seleccion[0]
        
        for widget in self.panel_formulario.winfo_children(): widget.destroy()
        self.entradas_dinamicas.clear()

        if "/" not in self.nodo_seleccionado: return

        categoria, item_key = self.nodo_seleccionado.split("/")
        
        if categoria == "orden":
            lista_datos = self.editor.datos[item_key]
            ttk.Label(self.panel_formulario, text=f"{item_key}:", font=("Arial", 10, "bold")).grid(row=0, column=0, sticky=tk.NW, pady=6, padx=5)
            widget_texto = tk.Text(self.panel_formulario, width=60, height=8, font=("Arial", 10), wrap=tk.WORD, relief=tk.SOLID, bd=1)
            widget_texto.insert("1.0", json.dumps(lista_datos, indent=4, ensure_ascii=False))
            widget_texto.grid(row=0, column=1, sticky=tk.EW, pady=6, padx=5)
            self.entradas_dinamicas[item_key] = (widget_texto, list, "lista_orden_widget")
            return

        sub_dicc = self.editor.datos[categoria][item_key]

        for fila, (campo, valor) in enumerate(sorted(sub_dicc.items())):
            ttk.Label(self.panel_formulario, text=f"{campo}:", font=("Arial", 9, "bold")).grid(row=fila, column=0, sticky=tk.NW, pady=6, padx=5)
            val_str = str(valor) if not isinstance(valor, (dict, list)) else json.dumps(valor)
            
            es_campo_ruta = "res://" in val_str or any(x in campo for x in ["foto", "imagen", "icono", "textura", "path", "ruta"])

            if "dato" in campo and not isinstance(valor, (dict, list)):
                widget_texto = tk.Text(self.panel_formulario, width=60, height=3, font=("Arial", 10), wrap=tk.WORD, relief=tk.SOLID, bd=1)
                widget_texto.insert("1.0", val_str)
                widget_texto.grid(row=fila, column=1, sticky=tk.EW, pady=6, padx=5)
                self.entradas_dinamicas[campo] = (widget_texto, type(valor), "text_widget")
                
            elif es_campo_ruta and not isinstance(valor, (dict, list)):
                frame_ruta = ttk.Frame(self.panel_formulario)
                frame_ruta.grid(row=fila, column=1, sticky=tk.EW, pady=6, padx=5)
                
                entry_ruta = ttk.Entry(frame_ruta, width=52)
                entry_ruta.insert(0, val_str)
                entry_ruta.pack(side=tk.LEFT, fill=tk.X, expand=True)
                
                btn_buscar = ttk.Button(frame_ruta, text="🔍", width=3, command=lambda e=entry_ruta: self.buscar_archivo_textura(e))
                btn_buscar.pack(side=tk.RIGHT, padx=2)
                
                self.entradas_dinamicas[campo] = (entry_ruta, type(valor), "entry_widget")
                
            else:
                widget_texto = ttk.Entry(self.panel_formulario, width=60)
                widget_texto.insert(0, val_str)
                widget_texto.grid(row=fila, column=1, sticky=tk.EW, pady=6, padx=5)
                self.entradas_dinamicas[campo] = (widget_texto, type(valor), "entry_widget")

    def buscar_archivo_textura(self, entrada_widget):
        tipos = [("Imágenes", "*.png *.jpg *.jpeg *.svg *.webp"), ("Todos los archivos", "*.*")]
        ruta_absolute = filedialog.askopenfilename(title="Seleccionar Textura/Imagen", filetypes=tipos)
        
        if ruta_absolute:
            try:
                ruta_relativa = os.path.relpath(ruta_absolute)
                ruta_relativa = ruta_relativa.replace("\\", "/")
                ruta_godot = f"res://{ruta_relativa}"
                
                entrada_widget.delete(0, tk.END)
                entrada_widget.insert(0, ruta_godot)
            except Exception as e:
                messagebox.showerror("Error", f"No se pudo calcular la ruta: {e}")

    def guardar_cambios_nodo_actual(self):
        if not self.nodo_seleccionado or "/" not in self.nodo_seleccionado or not self.entradas_dinamicas:
            return
        categoria, item_key = self.nodo_seleccionado.split("/")
        
        if categoria == "orden":
            if item_key not in self.editor.datos: return
            widget, _, _ = self.entradas_dinamicas[item_key]
            nuevo_valor_raw = widget.get("1.0", "end-1c").strip()
            try: self.editor.datos[item_key] = json.loads(nuevo_valor_raw)
            except Exception: pass
            return

        if item_key not in self.editor.datos.get(categoria, {}): return

        for campo, (widget, tipo_original, tipo_widget) in self.entradas_dinamicas.items():
            if tipo_widget == "text_widget": nuevo_valor_raw = widget.get("1.0", "end-1c").strip()
            else: nuevo_valor_raw = widget.get().strip()

            try:
                # TRUCO: Si empieza y termina con corchetes, FORZAMOS a que sea un Array real en el JSON
                if nuevo_valor_raw.startswith("[") and nuevo_valor_raw.endswith("]"):
                    string_limpio = nuevo_valor_raw.replace("'", '"')
                    self.editor.datos[categoria][item_key][campo] = json.loads(string_limpio)
                elif tipo_original == float: 
                    self.editor.datos[categoria][item_key][campo] = float(nuevo_valor_raw)
                elif tipo_original == int: 
                    self.editor.datos[categoria][item_key][campo] = int(nuevo_valor_raw)
                elif tipo_original in (dict, list): 
                    self.editor.datos[categoria][item_key][campo] = json.loads(nuevo_valor_raw)
                else: 
                    self.editor.datos[categoria][item_key][campo] = nuevo_valor_raw
            except Exception:
                # Si el JSON manual está mal escrito, lo deja como texto por seguridad
                self.editor.datos[categoria][item_key][campo] = nuevo_valor_raw

    def agregar_item(self):
        seleccion = self.arbol.selection()
        if not seleccion or "/" not in seleccion[0]: return
        categoria, item_key_origen = seleccion[0].split("/")
        if categoria == "orden": return

        win = tk.Toplevel(self)
        win.title("Nuevo Ítem")
        win.geometry("300x120")
        win.transient(self)
        win.grab_set()
        
        ttk.Label(win, text=f"ID Único ({categoria[:-1]}):").pack(pady=5)
        entry_id = ttk.Entry(win, width=30)
        entry_id.pack(pady=5)
        
        def confirmar():
            id_nuevo = entry_id.get().strip().lower().replace(" ", "_")
            if not id_nuevo or id_nuevo in self.editor.datos[categoria]: return
            
            plantilla = self.editor.datos[categoria][item_key_origen]
            self.editor.datos[categoria][id_nuevo] = {k: (list(v) if isinstance(v, list) else dict(v) if isinstance(v, dict) else v) for k, v in plantilla.items()}
            
            lista_orden = "orden_planta" if categoria == "plantas" else "orden_inportancia_mariposas"
            if lista_orden in self.editor.datos: self.editor.datos[lista_orden].append(id_nuevo)
            
            win.destroy()
            self.actualizar_arbol(f"{categoria}/{id_nuevo}")
        ttk.Button(win, text="Crear", command=confirmar).pack()

    def renombrar_item(self):
        seleccion = self.arbol.selection()
        if not seleccion or "/" not in seleccion[0]: return
        categoria, item_key_actual = seleccion[0].split("/")
        if categoria == "orden": return

        win = tk.Toplevel(self)
        win.title("Renombrar Clave")
        win.geometry("300x120")
        win.transient(self)
        win.grab_set()
        
        ttk.Label(win, text=f"Nuevo nombre clave para '{item_key_actual}':").pack(pady=5)
        entry_id = ttk.Entry(win, width=30)
        entry_id.pack(pady=5)
        entry_id.insert(0, item_key_actual)
        
        def confirmar():
            self.guardar_cambios_nodo_actual()
            id_nuevo = entry_id.get().strip().lower().replace(" ", "_")
            if not id_nuevo or id_nuevo == item_key_actual: 
                win.destroy()
                return
            if id_nuevo in self.editor.datos[categoria]:
                messagebox.showerror("Error", "Ese nombre clave ya existe.", parent=win)
                return
            
            self.editor.datos[categoria][id_nuevo] = self.editor.datos[categoria].pop(item_key_actual)
            
            lista_orden = "orden_planta" if categoria == "plantas" else "orden_inportancia_mariposas"
            if lista_orden in self.editor.datos and item_key_actual in self.editor.datos[lista_orden]:
                idx = self.editor.datos[lista_orden].index(item_key_actual)
                self.editor.datos[lista_orden][idx] = id_nuevo
            
            win.destroy()
            self.nodo_seleccionado = f"{categoria}/{id_nuevo}"
            self.actualizar_arbol(self.nodo_seleccionado)
            
        ttk.Button(win, text="Renombrar", command=confirmar).pack()

    def eliminar_item(self):
        seleccion = self.arbol.selection()
        if not seleccion or "/" not in seleccion[0]: return
        categoria, item_key = seleccion[0].split("/")
        if categoria == "orden": return

        if messagebox.askyesno("Borrar", f"¿Borrar '{item_key}'?"):
            del self.editor.datos[categoria][item_key]
            lista_orden = "orden_planta" if categoria == "plantas" else "orden_inportancia_mariposas"
            if lista_orden in self.editor.datos and item_key in self.editor.datos[lista_orden]: self.editor.datos[lista_orden].remove(item_key)
            
            # Limpieza total del panel derecho antes de reconstruir el árbol
            self.nodo_seleccionado = None
            for widget in self.panel_formulario.winfo_children(): widget.destroy()
            self.entradas_dinamicas.clear()
            
            self.actualizar_arbol()

    def añadir_campo_estructural(self):
        if not self.nodo_seleccionado or "/" not in self.nodo_seleccionado: return
        categoria, item_key_actual = self.nodo_seleccionado.split("/")
        if categoria not in ["mariposas", "plantas"]: return

        win = tk.Toplevel(self)
        win.title("Añadir Campo Global")
        win.geometry("350x180")
        win.transient(self)
        win.grab_set()

        ttk.Label(win, text=f"Nombre del campo para {categoria}:").pack(pady=5)
        entry_campo = ttk.Entry(win, width=35)
        entry_campo.pack(pady=5)

        ttk.Label(win, text="Tipo inicial:").pack(pady=5)
        combo_tipo = ttk.Combobox(win, values=["Texto (String)", "Número (Float)", "Lista vacía (Array)"], state="readonly", width=32)
        combo_tipo.current(0)
        combo_tipo.pack(pady=5)

        def ejecutar():
            nombre_campo = entry_campo.get().strip().lower().replace(" ", "_")
            if not nombre_campo: return
            primer_key = list(self.editor.datos[categoria].keys())[0]
            if nombre_campo in self.editor.datos[categoria][primer_key]: return

            tipo_sel = combo_tipo.current()
            valor_defecto = "" if tipo_sel == 0 else 0.0 if tipo_sel == 1 else []

            for item_id in self.editor.datos[categoria].keys():
                self.editor.datos[categoria][item_id][nombre_campo] = list(valor_defecto) if isinstance(valor_defecto, list) else valor_defecto

            win.destroy()
            
            # FIX: Limpiamos y desvinculamos la interfaz antes de recargar
            for widget in self.panel_formulario.winfo_children(): widget.destroy()
            self.entradas_dinamicas.clear()
            
            # Forzamos a la UI a simular que volvemos a clickear el elemento para redibujarlo limpio
            self.actualizar_arbol(f"{categoria}/{item_key_actual}")

        ttk.Button(win, text="Aplicar", command=ejecutar).pack(pady=5)

    def eliminar_campo_estructural(self):
        if not self.nodo_seleccionado or "/" not in self.nodo_seleccionado: return
        categoria, item_key_actual = self.nodo_seleccionado.split("/")
        if categoria not in ["mariposas", "plantas"]: return

        campos_disponibles = list(self.editor.datos[categoria][item_key_actual].keys())
        win = tk.Toplevel(self)
        win.title("Eliminar Campo")
        win.geometry("350x130")
        win.transient(self)
        win.grab_set()

        combo_campos = ttk.Combobox(win, values=campos_disponibles, state="readonly", width=35)
        combo_campos.pack(pady=10)

        def ejecutar():
            campo_a_borrar = combo_campos.get()
            if campo_a_borrar and messagebox.askyesno("Confirmar", f"¿Borrar '{campo_a_borrar}' en todo {categoria}?", parent=win):
                
                # FIX: Matamos las amarras de las entradas de texto dinámicas YA MISMO
                # Para que al cerrarse la ventana no intente auto-guardar cosas viejas
                for widget in self.panel_formulario.winfo_children(): widget.destroy()
                self.entradas_dinamicas.clear()
                
                # Borramos el campo de la base de datos real
                for item_id in self.editor.datos[categoria].keys():
                    if campo_a_borrar in self.editor.datos[categoria][item_id]: 
                        del self.editor.datos[categoria][item_id][campo_a_borrar]
                
                win.destroy()
                
                # Forzamos el redibujado absoluto del elemento sin el campo fantasma
                self.actualizar_arbol(f"{categoria}/{item_key_actual}")

        ttk.Button(win, text="Eliminar", command=ejecutar).pack()

if __name__ == "__main__":
    modelo = EditorDatos()
    app = AppEditor(modelo)
    app.mainloop()