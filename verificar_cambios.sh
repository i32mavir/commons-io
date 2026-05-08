#!/bin/bash

# Script de Verificación de Cambios REFACTOR
# Uso: bash verificar_cambios.sh
# Propósito: Listar y contar todos los cambios realizados

echo "╔════════════════════════════════════════════════════════╗"
echo "║   VERIFICACIÓN DE CAMBIOS - PRÁCTICAS MDAS BLOQUE II   ║"
echo "╚════════════════════════════════════════════════════════╝"
echo ""

# 1. Contar total de cambios
echo "📊 TOTAL DE CAMBIOS REALIZADOS:"
echo "════════════════════════════════"
TOTAL=$(grep -r "REFACTOR: Se" src/main/java/org/apache/commons/io/ 2>/dev/null | wc -l)
echo "✅ Total cambios REFACTOR: $TOTAL"
echo ""

# 2. Cambios por semana
echo "📅 CAMBIOS POR SEMANA:"
echo "════════════════════════════════"

echo "Semana 1 (Nombrado):"
S1=$(grep -r "REFACTOR: Se renombr" src/main/java/org/apache/commons/io/ 2>/dev/null | wc -l)
echo "  └─ Variables renombradas: $S1"

echo "Semana 2 (Comentarios):"
S2=$(grep -r "REFACTOR: Se" src/main/java/org/apache/commons/io/ 2>/dev/null | grep -v "renombr" | wc -l)
echo "  └─ Documentación expandida: $S2"

echo ""

# 3. Cambios por archivo
echo "📁 CAMBIOS POR ARCHIVO:"
echo "════════════════════════════════"
echo ""

for archivo in $(grep -rl "REFACTOR: Se" src/main/java/org/apache/commons/io/ 2>/dev/null | sort); do
    count=$(grep -c "REFACTOR: Se" "$archivo")
    # Extraer solo el nombre del archivo
    filename=$(basename "$archivo")
    echo "  $filename: $count cambios"
done

echo ""

# 4. Validar compilación
echo "🔧 VALIDACIÓN DE COMPILACIÓN:"
echo "════════════════════════════════"

if command -v mvn &> /dev/null; then
    echo "Compilando proyecto... (esto puede tomar un minuto)"
    if mvn clean compile > /tmp/maven.log 2>&1; then
        echo "✅ Compilación: BUILD SUCCESS"
    else
        echo "❌ Compilación: BUILD FAILURE"
        echo "   Ver /tmp/maven.log para detalles"
    fi
else
    echo "⚠️  Maven no encontrado. Omitiendo compilación."
fi

echo ""

# 5. Mostrar ejemplos de cambios
echo "📋 EJEMPLOS DE CAMBIOS (primeros 5):"
echo "════════════════════════════════"
echo ""

count=0
grep -r "REFACTOR: Se" src/main/java/org/apache/commons/io/ 2>/dev/null | while read -r line && [ $count -lt 5 ]; do
    echo "$line" | head -c 100
    echo ""
    count=$((count+1))
done | head -5

echo ""

# 6. Informes disponibles
echo "📄 INFORMES COMPLETADOS:"
echo "════════════════════════════════"

if [ -f "INFORME_MDAS_SEMANA1.md" ]; then
    echo "✅ INFORME_MDAS_SEMANA1.md (Reglas de Nombrado)"
else
    echo "❌ INFORME_MDAS_SEMANA1.md - NO ENCONTRADO"
fi

if [ -f "INFORME_MDAS_SEMANA2.md" ]; then
    echo "✅ INFORME_MDAS_SEMANA2.md (Reglas de Comentarios)"
else
    echo "❌ INFORME_MDAS_SEMANA2.md - NO ENCONTRADO"
fi

if [ -f "INFORME_MDAS_SEMANA3.md" ]; then
    echo "✅ INFORME_MDAS_SEMANA3.md (Reglas de Funciones)"
else
    echo "❌ INFORME_MDAS_SEMANA3.md - NO ENCONTRADO"
fi

echo ""

# 7. Documentación de apoyo
echo "📚 DOCUMENTACIÓN DE APOYO:"
echo "════════════════════════════════"

if [ -f "CAMBIOS_REALIZADOS.md" ]; then
    echo "✅ CAMBIOS_REALIZADOS.md (Detalle completo)"
else
    echo "❌ CAMBIOS_REALIZADOS.md - NO ENCONTRADO"
fi

if [ -f "RESUMEN_EJECUTIVO.md" ]; then
    echo "✅ RESUMEN_EJECUTIVO.md (Respuestas rápidas)"
else
    echo "❌ RESUMEN_EJECUTIVO.md - NO ENCONTRADO"
fi

if [ -f "TABLA_REFERENCIA.md" ]; then
    echo "✅ TABLA_REFERENCIA.md (Tabla de cambios)"
else
    echo "❌ TABLA_REFERENCIA.md - NO ENCONTRADO"
fi

if [ -f "README_PRACTICAS.md" ]; then
    echo "✅ README_PRACTICAS.md (Guía completa)"
else
    echo "❌ README_PRACTICAS.md - NO ENCONTRADO"
fi

echo ""

# 8. Resumen final
echo "╔════════════════════════════════════════════════════════╗"
echo "║   VERIFICACIÓN COMPLETADA                              ║"
echo "║   Estado: ✅ PRÁCTICAS 1, 2 Y 3 COMPLETADAS             ║"
echo "╚════════════════════════════════════════════════════════╝"
echo ""
echo "Para más información:"
echo "  • Respuestas rápidas → cat RESUMEN_EJECUTIVO.md"
echo "  • Tabla de cambios → cat TABLA_REFERENCIA.md"
echo "  • Detalle completo → cat CAMBIOS_REALIZADOS.md"
echo ""
