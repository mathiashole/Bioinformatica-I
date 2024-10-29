# Proyecto de Bioinformática I

# Introducción

Este documento contiene dos ejercicios desarrollados en **Python** y **Bash** para realizar análisis relacionados con secuencias biológicas.

## Estructura del Proyecto

- **Ejercicio 1 (Python):** Búsqueda de motivos en secuencias de ADN con coincidencias exactas e inexactas.  
- **Ejercicio 2 (Bash):** Alineamiento y evaluación de secuencias utilizando múltiples algoritmos.

## Requisitos

### Python  
- **Python**  
- Recomendado: Ejecutar en **Google Colab** para mayor facilidad.  

### Bash  
- Herramientas necesarias:  
  - `mafft`, `muscle`, `clustalw`, `poa`, `seqret`, `edialign`  
  - **Bali-score** para evaluar los alineamientos.

---

## Ejercicio 1: Búsqueda de motivos en ADN (Python)

Este script permite encontrar motivos específicos en secuencias de ADN. Admite coincidencias exactas e inexactas con un número máximo de *mismatches* permitido.

### Uso  

1. Clona el repositorio e ingresa a la carpeta del proyecto:
   ```bash
   git clone <tu-repositorio-url>
   cd <nombre-del-repositorio>
   ```
