# 📜 REGLAS DEL CHALLENGE “El Proxy Guardián — Salvando una App Maldita con Nginx”

**Este no es un examen**. Es una oportunidad para demostrar **cómo piensas**, cómo resuelves problemas reales de seguridad, y **cómo aplicas tus conocimientos actuales en un entorno controlado.**

No buscamos perfección técnica — buscamos curiosidad, creatividad, ética y atención al detalle.

## Reglas técnicas

1. Uso exclusivo de herramientas **open source**.
2. Énfasis en **pensamiento crítico**, **creatividad** y **atención al detalle**.
3. **No modifcar la app vulnerable**
   1. Prohibido modificar `app/server.js` y `app/user.js`.
   > Todas las mitigaciones deben hacerse desde la capa de Nginx: esto simula un escenario real: no siempre puedes tocar el código de la app.
4. No modificar o eliminar los scripts brindados
   1. Los scripts en `scripts-challenge/` son necesarios para las pruebas.
   > Puedes ejecutarlos, leerlos, aprender de ellos — pero no alterarlos.
5. Configuración de Nginx con Open Source:
   1. Si usas módulos compilados (como Lua), debes:
      1. Documentar paso a paso cómo lo instalaste/configuraste.
      2. Asegurar que es reproducible en cualquier entorno Linux estándar.
   > No se aceptan soluciones que dependan de Nginx Plus.

## Reglas de ética y uso de la IA

7. PROHIBIDO EL USO DE IA SIN INTERVENCIÓN HUMANA PROFUNDA:

    *Si bien en el dia a dia uno utiliza modelos de IA para agilizar ciertas tareas, la idea de este desafio es realizarla con los conocimientos actuales y la documentacion oficial.*

    Este challenge está diseñado para evaluar tu capacidad de análisis, pensamiento lateral y atención al detalle — habilidades que una IA no puede replicar sin tu guía consciente.

    ¿Qué significa esto?

    **Puedes usar IA como asistente:**
    - Entender conceptos específicos (ej: “¿cómo funciona rate limiting en Nginx?”).
    - Revisar sintaxis o formato.
    - Sugerir herramientas open source.
    - Sugerir enfoques

    **NO puedes usar IA para:**
    - Copiar/pegar soluciones completas de IA: si tu entrega parece generada por una IA (sin personalización, sin entender el contexto, sin superar las trampas), será invalidada automáticamente.
    - Generar configuraciones de Nginx sin entenderlas.
    - Copiar/pegar soluciones sin personalización ni análisis.
    - Ignorar las trampas anti-IA (están diseñadas para humanos curiosos).
    - La ética, honestidad y la sincerdad son importantes, por lo cual se valora el cumplir con lo solicitado.

    En caso de utilizar un IA, se recomienda lo siguiente:
    - Realizar sugerencias de herramientas extras a utilizar (deben ser open source).
8. Aclarar en el README.md del entregable para qué se utilizó la IA y en qué casos de un día de trabajo la hubieras utilizado sin no tuvieras estas restricciones.
<!-- 9. Documentar el proceso, NO SOLO TU RESULTADO
En tu README.md, explica:
Qué intentaste.
Qué falló y por qué.
Cómo llegaste a tu solución.
→ Valoramos el proceso de pensamiento más que la solución perfecta. -->

## Reglas de entorno

En DevSecOps, a menudo heredas sistemas, entornos rotos, o máquinas limpias donde todo debe construirse desde cero. Este challenge simula eso.

9. Entorno obligatorio: máquina virtual con Lubuntu o Kali Linux.

    **¿Por qué?**

    - Evalúa tu capacidad para configurar un entorno desde cero: instalar Docker, Nginx, Node.js, herramientas de línea de comandos.
    - Simula un escenario real: muchas veces debes trabajar en máquinas provisionadas, sin herramientas preinstaladas.
    - El uso de máquinas virtuales es estándar en entornos de seguridad, pentesting y DevSecOps — queremos ver cómo te desenvuelves. En caso de que sea la primera vez, puedes solicitar ayuda.
    > No se aceptan entregas hechas en WSL/WSL2, Docker Desktop sin VM, sistemas host directos, entornos preconfigurados o con herramientas ya instaladas (a menos que tú las hayas instalado).
10.  Mantener la licencia del proyecto: es parte de nuestra cultura DevSecOps.