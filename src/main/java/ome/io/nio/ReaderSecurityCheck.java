/*
 * Copyright (C) 2019 University of Dundee & Open Microscopy Environment.
 * All rights reserved.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
 */

package ome.io.nio;

import loci.formats.IFormatReader;
import ome.conditions.SecurityViolation;

/**
 * Check that OMERO permissions violations are not being attempted by means of a Bio-Formats readers' I/O.
 * Cf. 2019-SV1.
 * @author m.t.b.carroll@dundee.ac.uk
 * @since 5.5.5
 */
public interface ReaderSecurityCheck {

    /**
     * Check that the used files reported by the reader are safe.
     * Call as next step after {@link IFormatReader#setId(String)}.
     * @param reader an open Bio-Formats reader
     * @throws SecurityViolation if a security issue was identified with any of the used files reported by the reader
     */
    void assertUsedFilesReadable(IFormatReader reader) throws SecurityViolation;
}
