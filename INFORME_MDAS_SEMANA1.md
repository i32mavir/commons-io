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

**Impacto:** Sin cambio semántico. Mejora significativa de legibilidad en método complejo.

---

### Verificación de Funcionalidad

- [x] Compilación sin errores tras refactorización
- [x] Todos los cambios registro en commit Git
- [x] Sin cambios en semántica del código
- [x] Mejora en legibilidad y mantenibilidad

### Herramientas de IA Utilizadas

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
- [ ] Aplicar cambios en HexDump.java (opcional - bucles dentro de bucles)
- [ ] Generar reporte PDF final con capturas

---

### Commits Realizados

```
9f28706d6 REFACTOR: Semana 1 - Nombres descriptivos (IOUtils, BOMInputStream, FileAlterationObserver)
```

---

**Última actualización:** 23 de abril de 2026  
**Estado:** ✅ SEMANA 1 COMPLETADA
