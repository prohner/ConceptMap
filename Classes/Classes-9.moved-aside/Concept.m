// 
//  Concept.m
//  ConceptMap
//
//  Created by Preston Rohner on 10/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Concept.h"

#import "ConnectedConcept.h"
#import "Document.h"
#import "ConceptObject.h"

@implementation Concept 

@synthesize conceptObject;

@dynamic bodyDisplayString;
@dynamic lastSaved;
@dynamic width;
@dynamic originY;
@dynamic title;
@dynamic backgroundImage;
@dynamic height;
@dynamic created;
@dynamic fontSize;
@dynamic colorSchemeConstant;
@dynamic fontName;
@dynamic originX;
@dynamic concepts;
@dynamic parentConcept;
@dynamic connectedConcepts;
@dynamic document;

@end
