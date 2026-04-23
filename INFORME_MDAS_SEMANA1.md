# Informe de Prácticas MDAS - Bloque II: Código Limpio y Refactorización
## Proyecto: Apache Commons IO

**Curso:** 2025/2026  
**Semana:** 1  
**Tema:** Reglas de Nombrado

---

## Portada
**Integrantes del grupo:**
- [Nombre del alumno/equipo]

**Enlace al repositorio:** https://github.com/[usuario]/commons-io

---

## Semana 1: Reglas de Nombrado

### Objetivo
Aplicar las reglas de código limpio relacionadas con nomenclatura según el libro "Clean Code" de Robert C. Martin:
- Nombres descriptos que revelan intención
- Evitar desinformación
- Hacer distinciones significativas
- Usar nombres pronunciables
- Usar nombres buscables
- Evitar codificaciones
- No usar prefijos o sufijos de miembro
- Evitar variables de una sola letra (excepto bucles)
- Nombres de clases (sustantivos)
- Nombres de métodos (verbos)
- No ser demasiado ingenioso

### Análisis Realizado

Se ha analizado el código fuente del proyecto Apache Commons IO identificando las siguientes violaciones de reglas de nombrado:

#### Problemas Identificados:

1. **Variables single-letter poco descriptivas en métodos**
   - Ubicación: `IOUtils.java`, línea 2616
   - Código original: `final int n = input.read(skipByteBuffer);`
   - Problema: La variable `n` no es descriptiva
   
2. **Variables con nombres muy cortos**
   - Ubicación: `BOMInputStream.java`, línea 431
   - Código original: `int b = 0;`
   - Problema: `b` es una abreviación poco clara
   
3. **Variables intermedias poco claras**
   - Ubicación: `FileAlterationObserver.java`, línea 359
   - Código original: `int c = 0;`
   - Problema: `c` podría referirse a muchas cosas diferentes

4. **Parámetros con nombres muy cortos**
   - Ubicación: `HexDump.java`, líneas 131, 139, 205, 219
   - Código original: Variables `j` y `k`
   - Problema: Aunque sean bucles anidados, falta claridad sobre su propósito

### Cambios Realizados

#### Cambio 1: IOUtils.java - Variable descriptiva para lectura de datos
**Archivo:** `src/main/java/org/apache/commons/io/IOUtils.java`  
**Línea:** 2616  
**Regla Aplicada:** Nombres descriptivos que revelen intención (Clean Code - Capítulo 2)

**ANTES:**
```java
final int n = input.read(skipByteBuffer);
if (n == EOF) {
    break;
}
remain -= n;
```

**DESPUÉS:**
```java
// REFACTOR: Renamed 'n' to 'bytesRead' to reveal intent clearly
final int bytesRead = input.read(skipByteBuffer);
if (bytesRead == EOF) {
    break;
}
remain -= bytesRead;
```

**Justificación:** El nombre de variable `n` es una letra aislada que no revela intención. El nuevo nombre `bytesRead` comunica claramente que almacena el número de bytes leídos del stream, mejorando significativamente la legibilidad del código.

**Impacto:** Sin cambio semántico. Solo mejora la comprensión del código.

---

#### Cambio 2: BOMInputStream.java - Variable clara para lectura de bytes
**Archivo:** `src/main/java/org/apache/commons/io/input/BOMInputStream.java`  
**Línea:** 431  
**Regla Aplicada:** Nombres pronunciables y descriptivos

**ANTES:**
```java
int b = 0;
while (len > 0 && b >= 0) {
    b = readFirstBytes();
    if (b >= 0) {
        buf[off++] = (byte) (b & 0xFF);
```

**DESPUÉS:**
```java
// REFACTOR: Renamed 'b' to 'byteValue' for clarity and descriptiveness
int byteValue = 0;
while (len > 0 && byteValue >= 0) {
    byteValue = readFirstBytes();
    if (byteValue >= 0) {
        buf[off++] = (byte) (byteValue & 0xFF);
```

**Justificación:** La variable `b` es una abreviación que no cumple la regla de nombres pronunciables. `byteValue` es más descriptivo y comunica que contiene un valor de byte leído del BOM (Byte Order Mark).

**Impacto:** Sin cambio semántico. Mejora la comprensión en contexto de BOM parsing.

---

#### Cambio 3: FileAlterationObserver.java - Índice con nombre significativo
**Archivo:** `src/main/java/org/apache/commons/io/monitor/FileAlterationObserver.java`  
**Método:** `checkAndFire()`  
**Líneas:** 359 en adelante  
**Regla Aplicada:** Nombres buscables y significativos (Clean Code - Evitar variables single-letter excepto bucles)

**ANTES:**
```java
int c = 0;
final FileEntry[] actualEntries = currentEntries.length > 0 ? 
    new FileEntry[currentEntries.length] : FileEntry.EMPTY_FILE_ENTRY_ARRAY;
for (final FileEntry previousEntry : previousEntries) {
    while (c < currentEntries.length && comparator.compare(previousEntry.getFile(), currentEntries[c]) > 0) {
        actualEntries[c] = createFileEntry(parentEntry, currentEntries[c]);
        fireOnCreate(actualEntries[c]);
        c++;
    }
    if (c < currentEntries.length && comparator.compare(previousEntry.getFile(), currentEntries[c]) == 0) {
        // ... más código usando c
    }
}
for (; c < currentEntries.length; c++) {
    actualEntries[c] = createFileEntry(parentEntry, currentEntries[c]);
    fireOnCreate(actualEntries[c]);
}
```

**DESPUÉS:**
```java
// REFACTOR: Renamed 'c' to 'currentEntryIndex' to reveal intent as index counter
int currentEntryIndex = 0;
final FileEntry[] actualEntries = currentEntries.length > 0 ? 
    new FileEntry[currentEntries.length] : FileEntry.EMPTY_FILE_ENTRY_ARRAY;
for (final FileEntry previousEntry : previousEntries) {
    while (currentEntryIndex < currentEntries.length && 
           comparator.compare(previousEntry.getFile(), currentEntries[currentEntryIndex]) > 0) {
        actualEntries[currentEntryIndex] = createFileEntry(parentEntry, currentEntries[currentEntryIndex]);
        fireOnCreate(actualEntries[currentEntryIndex]);
        currentEntryIndex++;
    }
    if (currentEntryIndex < currentEntries.length && 
        comparator.compare(previousEntry.getFile(), currentEntries[currentEntryIndex]) == 0) {
        // ... más código usando currentEntryIndex
    }
}
for (; currentEntryIndex < currentEntries.length; currentEntryIndex++) {
    actualEntries[currentEntryIndex] = createFileEntry(parentEntry, currentEntries[currentEntryIndex]);
    fireOnCreate(actualEntries[currentEntryIndex]);
}
```

**Justificación:** La variable `c` viola múltiples reglas de Clean Code:
1. No es pronunciable
2. No es buscable (la letra 'c' aparece en múltiples contextos)
3. No revela intención en el contexto de comparación y sincronización de arrays

El nuevo nombre `currentEntryIndex` es:
- **Descriptivo:** comunica que es un índice
- **Buscable:** se puede buscar así en todo el código
- **Significativo:** revela el propósito en el contexto del método

---

### Cambio 4: HexDump.java - Bucles anidados con nombres claros
**Archivo:** `src/main/java/org/apache/commons/io/HexDump.java`  
**Línea:** 124 en adelante  
**Regla Aplicada:** Evitar variables single-letter que no revelan intención

**Cambios realizados:**
- `j` → `byteOffset` (itera en grupos de 16 bytes)
- `k` → `byteIndexInGroup` (índice dentro del grupo)
- `chars_read` → `bytesInGroup` (claro que son bytes, no caracteres)
- `display_offset` → `displayOffset` (camelCase)

**Justificación:** En bucles anidados complejos que manipulan datos hexadecimales, nombres específicos como `byteOffset` y `byteIndexInGroup` comunican claramente el propósito de cada índice. El cambio de `chars_read` a `bytesInGroup` también corrige una imprecisión semántica.

---

### Cambio 5: AbstractByteArrayOutputStream.java - Variables de copia
**Archivo:** `src/main/java/org/apache/commons/io/output/AbstractByteArrayOutputStream.java`  
**Líneas:** 221, 267  
**Regla Aplicada:** Nombres descriptivos para operaciones principales

**Cambios realizados:**
- `c` → `bytesToCopy` (en `toByteArray()`)
- `c` → `bytesToInclude` (en `toInputStream()`)

**Justificación:** La variable `c` es demasiado genérica. El nuevo nombre indica claramente qué cantidad de bytes se copiarán/incluirán en la iteración actual.

---

### Cambio 6: WriterOutputStream.java - Bytes a codificar
**Archivo:** `src/main/java/org/apache/commons/io/output/WriterOutputStream.java`  
**Línea:** 458  
**Regla Aplicada:** Nombres reveladores de intención

**Cambios realizados:**
- `c` → `bytesToEncode`

**Justificación:** `bytesToEncode` comunica claramente que en cada iteración se procesan esa cantidad de bytes para codificación.

---

### Cambio 7: ReaderInputStream.java - Bytes a leer
**Archivo:** `src/main/java/org/apache/commons/io/input/ReaderInputStream.java`  
**Línea:** 463  
**Regla Aplicada:** Nombres pronunciables y significativos

**Cambios realizados:**
- `c` → `bytesToRead`

**Justificación:** Similar a WriterOutputStream, `bytesToRead` es mucho más descriptivo en el contexto de lectura de bytes del buffer.

---

### Cambio 8: ReversedLinesFileReader.java - Búsqueda de secuencias
**Archivo:** `src/main/java/org/apache/commons/io/input/ReversedLinesFileReader.java`  
**Método:** `getNewLineMatchByteCount()`  
**Línea:** 191-192  
**Regla Aplicada:** Nombres buscables y significativos

**Cambios realizados:**
- `j` → `sequenceIndex`
- `k` → `bufferIndex`

**Justificación:** En un contexto de búsqueda de patrones complejos, `sequenceIndex` y `bufferIndex` son mucho más descriptivos que `j` y `k`. Ahora es claro que uno itera la secuencia y otro representa el índice en el buffer.

---

### Resumen de Refactorizaciones Realizadas

| Archivo | Variable | Nuevo Nombre | Contexto |
|---------|----------|--------------|----------|
| IOUtils.java | n | bytesRead | Lectura de stream |
| BOMInputStream.java | b | byteValue | Valor de byte en BOM |
| FileAlterationObserver.java | c | currentEntryIndex | Índice en array de archivos |
| HexDump.java | j | byteOffset | Offset en bloques de 16 |
| HexDump.java | k | byteIndexInGroup | Índice dentro del grupo |
| HexDump.java | chars_read | bytesInGroup | Bytes en grupo actual |
| HexDump.java | j | hexDigitIndex | Iteración en dígitos hex |
| AbstractByteArrayOutputStream.java | c | bytesToCopy | Bytes a copiar |
| AbstractByteArrayOutputStream.java | c | bytesToInclude | Bytes para constructor |
| WriterOutputStream.java | c | bytesToEncode | Bytes a codificar |
| ReaderInputStream.java | c | bytesToRead | Bytes a leer |
| ReversedLinesFileReader.java | j | sequenceIndex | Índice en secuencia |
| ReversedLinesFileReader.java | k | bufferIndex | Índice en buffer |

---

### Verificación de Funcionalidad

- [x] Compilación sin errores tras refactorización
- [x] Todos los cambios registrados en commits Git
- [x] Sin cambios en semántica del código
- [x] Mejora significativa en legibilidad y mantenibilidad



**Herramienta:** GitHub Copilot (Claude Haiku 4.5)  
**Versión:** Copilot Chat  
**Uso:** Análisis de código para detectar patrones de nombres poco descriptivos  

**Ejemplo de prompt:**
```
Identifica variables con nombres de una o dos letras que violen las reglas de 
código limpio en este método Java. Sugiere nombres más descriptivos basados en 
el contexto del código.
```

### Pendientes

- [x] Aplicar cambios en archivos identificados
- [x] Refactorizar nombres en HexDump.java (bucles anidados)
- [x] Refactorizar nombres en AbstractByteArrayOutputStream.java
- [x] Refactorizar nombres en WriterOutputStream.java
- [x] Refactorizar nombres en ReaderInputStream.java
- [x] Refactorizar nombres en ReversedLinesFileReader.java
- [ ] Generar reporte PDF final con capturas

---

### Commits Realizados

```
9f28706d6 REFACTOR: Semana 1 - Nombres descriptivos (IOUtils, BOMInputStream, FileAlterationObserver)
7b9bfed9e DOCS: Actualizar informe Semana 1 con ejemplos detallados y justificaciones
ed01e3bff REFACTOR: Nombres descriptivos en HexDump, AbstractByteArrayOutputStream, WriterOutputStream, ReaderInputStream, ReversedLinesFileReader
```

---

**Última actualización:** 23 de abril de 2026  
**Estado:** ✅ SEMANA 1 COMPLETADA - Refactorizaciones de Nomenclatura Finalizadas
