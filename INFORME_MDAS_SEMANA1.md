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

#### Cambio 1: IOUtils.java - Variables de lectura de datos
**Línea:** 2616  
**Regla Aplicada:** Nombres descriptivos que revelen intención  

```java
// ANTES
final int n = input.read(skipByteBuffer);

// DESPUÉS  
final int bytesRead = input.read(skipByteBuffer);
```

**Justificación:** El nombre `bytesRead` es mucho más claro que `n`, indicando que almacena el número de bytes leídos.

---

#### Cambio 2: BOMInputStream.java - Variable de byte
**Línea:** 431  
**Regla Aplicada:** Nombres pronunciables y descriptivos

```java
// ANTES
int b = 0;

// DESPUÉS
int byteValue = 0;
```

**Justificación:** `byteValue` describe claramente que contendrá un valor de byte, mejorando la legibilidad.

---

#### Cambio 3: FileAlterationObserver.java - Contador de eventos
**Línea:** 359  
**Regla Aplicada:** Nombres que revelen intención

```java
// ANTES
int c = 0;

// DESPUÉS
int eventCount = 0;
```

**Justificación:** Basado en el contexto de observador de cambios en archivos, `eventCount` es más descriptivo que `c`.

---

### Verificación de Funcionalidad

- [x] Compilación sin errores tras refactorización
- [x] Tests ejecutados correctamente
- [x] Sin cambios en semántica del código

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

- [ ] Aplicar cambios en más archivos
- [ ] Generar report PDF final

---

**Última actualización:** 23 de abril de 2026  
**Estado:** En progreso
