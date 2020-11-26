//
//  EnhancedMetaFilePresentationDataHeight.swift
//
//
//  Created by Hugh Bellamy on 25/11/2020.
//

/// [MS-OLEDS] 2.1.11 EnhancedMetaFilePresentationDataHeight
/// This MUST be a long value that contains the height of an enhanced metafile (as specified in [MS-EMF] section 1.3.1) in logical units.
/// The MM_HIMETRIC mapping mode (as specified in [MS-EMF] section 2.1.21) MUST be used to convert the logical units to physical units.
public typealias EnhancedMetaFilePresentationDataHeight = Int32
