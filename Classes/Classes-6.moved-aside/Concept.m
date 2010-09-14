// 
//  Concept.m
//  ConceptMap
//
//  Created by Preston Rohner on 9/10/10.
//  Copyright 2010 Cool Tool Apps. All rights reserved.
//

#import "Concept.h"

#import "Document.h"

@implementation Concept 

@dynamic title;
@dynamic document;
@dynamic parentConcept;
@dynamic concepts;

- (void)awakeFromInsert {
	[self setValue:[NSDate date] forKey:@"created"];
}

- (void)willSave {
    [self setPrimitiveValue: [NSDate date] forKey: @"lastSaved"];
}

@end
