# Proyecto de Bioinformática I

# Introducción

Este documento contiene dos ejercicios desarrollados en **Python** y **Bash**.

## Estructura del Proyecto

- **Ejercicio 1 (Python):** Búsqueda de motivos en secuencias de ADN con coincidencias exactas e inexactas.  
- **Ejercicio 2 (Bash):** Alineamiento y evaluación de Alineamiento utilizando múltiples algoritmos.

## Requisitos

### Python  
- **Python**  
- Recomendado: Ejecutar en **Google Colab** para mayor facilidad.  

### Bash  
- Herramientas necesarias:  
  - `mafft`, `muscle`, `clustalw`, `poa`, `seqret`, `edialign`
  - **BaliBase** para tener alineamientos de referencia.  
  - **Bali-score** para evaluar los alineamientos.

---

## Ejercicio 1: Búsqueda de motivos en ADN (Python)

Este programa permite encontrar motivos específicos en secuencias de ADN. Admite coincidencias exactas e inexactas con un número máximo de *mismatches* permitido.

### Uso  

1. Clona el repositorio e ingresa a la carpeta del proyecto:
   ```bash
   git clone <tu-repositorio-url>
   cd <nombre-del-repositorio>
   ```
2. Abre Google Colab con el respectivo codigo de `Ejercicio1.ipynb`.

3.  Al ejecutar el script, sigue estos pasos:
        Introduce una secuencia de ADN de al menos 6 nucleótidos.
        Ingresa un motivo de exactamente 6 nucleótidos.
        Elige entre coincidencia exacta o inexacta.
        En caso de coincidencia inexacta, proporciona el número máximo de mismatches permitidos.

#### Ejemplo de Ejecución

```yaml

Introduce aquí la secuencia de ADN que deseas analizar: ATGCTAGCTACGTA  
Introduce el motivo (debe tener un largo de 6 nucleótidos): ATGCTA  
Introduce la modalidad deseada:
  (a) Exacto
  (b) Inexacto
b
Introduce el número de mismatches permitidos (entre 1 y 6): 2
Lista de las ocurrencias encontradas y sus posiciones en la secuencia:
ATGCTA : 1-6
```

## Ejercicio 2: Alineamiento de secuencias (Bash)

Este script realiza alineamientos utilizando varios algoritmos (MAFFT, MUSCLE, ClustalW, POA, Dialign) y evalúa los resultados con Bali-score.

### Uso

1.  Clona el repositorio:

```bash

git clone <tu-repositorio-url>
cd <nombre-del-repositorio>
```

2.  Asegúrate de tener instaladas las herramientas mafft muscle clustalw emboss poa t-coffee dialign

3.  Provee las rutas de los benchmarks como argumentos:

```bash

    ./alignment_socre_balibase.sh <ruta_benchmark1> <ruta_benchmark2> ... <ruta_benchmarkN>
```    

El script realiza alineamientos con múltiples algoritmos, convierte los resultados a formato MSF, evalúa los alineamientos con BaliScore y guarda los resultados en un archivo TSV.

#### Ejemplo de Ejecución

```bash

./alignment_socre_balibase.sh /ruta/al/benchmark1 /ruta/al/benchmark2

```