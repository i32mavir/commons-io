/*
 * Licensed to the Apache Software Foundation (ASF) under one or more
 * contributor license agreements.  See the NOTICE file distributed with
 * this work for additional information regarding copyright ownership.
 * The ASF licenses this file to You under the Apache License, Version 2.0
 * (the "License"); you may not use this file except in compliance with
 * the License.  You may obtain a copy of the License at
 *
 *      https://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.apache.commons.io;

import java.time.Duration;
import java.time.Instant;

/**
 * Helps work with threads.
 *
 * @since 2.12.0
 */
public final class ThreadUtils {

    /**
     * Extracts the nanosecond component within the millisecond part of a duration.
     * <p>
     * For a duration like 2.5 milliseconds (2500000 nanoseconds), this method returns 500000 
     * (the nanoseconds beyond the millisecond boundary). This is used by the sleep method to 
     * preserve sub-millisecond precision when passing arguments to {@link Thread#sleep(long, int)}.
     * </p>
     * <!-- REFACTOR: Se añadió javadoc a método auxiliar sin documentación explicando su propósito
     *      y por qué es necesario para temporización precisa de sleep -->
     *
     * @param duration the duration to extract nanoseconds from.
     * @return nanoseconds beyond the millisecond boundary (0-999999 range).
     */
    private static int getNanosOfMilli(final Duration duration) {
        return duration.getNano() % 1_000_000;
    }

    /**
     * Sleeps for a guaranteed minimum duration unless interrupted.
     * <p>
     * This method exists because {@link Thread#sleep(long)} can sleep for 0, 70, 100, or 200ms 
     * or any other duration the OS scheduler deems appropriate. Read {@link Thread#sleep(long, int)} 
     * for further interesting details.
     * </p>
     * <h2>Implementation Strategy: Looping Until Target Time</h2>
     * <p>
     * Rather than trusting a single sleep call, this method loops and recalculates the remaining  
     * duration after each sleep cycle. This ensures the thread sleeps for at least the requested 
     * duration by accounting for OS scheduler inaccuracies:
     * <ul>
     * <li><strong>Primary approach:</strong> Uses {@code System.nanoTime()} which is monotonic and 
     *     immune to system clock adjustments (DST changes, manual time corrections).</li>
     * <li><strong>Fallback approach:</strong> Uses {@code Instant.now()} if nanoTime calculation 
     *     causes overflow (very large durations).</li>
     * </ul>
     * </p>
     * <!-- REFACTOR: Se expandió javadoc para explicar la decisión de diseño de hacer loop vs single sleep,
     *      se documentaron las dos estrategias de cálculo de tiempo, y se aclaró por qué cada una es necesaria -->
     *
     * @param duration the sleep duration.
     * @throws InterruptedException if interrupted.
     * @see Thread#sleep(long, int)
     */
    public static void sleep(final Duration duration) throws InterruptedException {
        // Using this method avoids depending on the vagaries of the precision and accuracy of system timers and schedulers.
        try {
            // PRIMARY STRATEGY: Use JVM elapsed time via System.nanoTime()
            // This avoids issues with DST changes and manual OS time changes
            final long nanoStart = System.nanoTime();
            // toNanos(): Possible ArithmeticException on very large durations (wrap around is OK)
            final long finishNanos = nanoStart + duration.toNanos();
            Duration remainingDuration = duration;
            long nowNano;
            do {
                Thread.sleep(remainingDuration.toMillis(), getNanosOfMilli(remainingDuration));
                nowNano = System.nanoTime();
                remainingDuration = Duration.ofNanos(finishNanos - nowNano);
            } while (nowNano - finishNanos < 0); // handles wrap around, see Thread#sleep(long, int)
        } catch (final ArithmeticException e) {
            // FALLBACK STRATEGY: Use wall-clock time via Instant.now() when nanoTime overflows
            // This handles extremely large durations where toNanos() would overflow
            final Instant finishInstant = Instant.now().plus(duration);
            Duration remainingDuration = duration;
            do {
                Thread.sleep(remainingDuration.toMillis(), getNanosOfMilli(remainingDuration));
                remainingDuration = Duration.between(Instant.now(), finishInstant);
            } while (!remainingDuration.isNegative());
        }
    }

    /**
     * Make private in 3.0.
     *
     * @deprecated TODO Make private in 3.0.
     */
    @Deprecated
    public ThreadUtils() {
        // empty
    }
}
