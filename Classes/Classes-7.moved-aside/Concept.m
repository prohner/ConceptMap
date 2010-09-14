// 
//  Concept.m
//  ConceptMap
//
//  Created by Preston Rohner on 9/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Concept.h"

#import "Document.h"

@implementation Concept 

@dynamic height;
@dynamic title;
@dynamic created;
@dynamic width;
@dynamic originY;
@dynamic originX;
@dynamic parentConcept;
@dynamic document;
@dynamic concepts;

- (void)awakeFromInsert {
	[self setValue:[NSDate date] forKey:@"created"];
}
- (void)willSave {
	[self setPrimitiveValue: [NSDate date] forKey: @"lastSaved"];
}

@end
