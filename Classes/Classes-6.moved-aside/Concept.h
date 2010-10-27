//
//  Concept.h
//  ConceptMap
//
//  Created by Preston Rohner on 10/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Document;
@class ConceptObject;

@interface Concept :  NSManagedObject  
{
	ConceptObject *conceptObject;
}

@property (nonatomic, retain) NSString * bodyDisplayString;
@property (nonatomic, retain) NSNumber * fontSize;
@property (nonatomic, retain) NSNumber * width;
@property (nonatomic, retain) NSNumber * originY;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * height;
@property (nonatomic, retain) NSDate * created;
@property (nonatomic, retain) NSNumber * colorSchemeConstant;
@property (nonatomic, retain) NSString * fontName;
@property (nonatomic, retain) NSNumber * originX;
@property (nonatomic, retain) NSDate * lastSaved;
@property (nonatomic, retain) NSSet* concepts;
@property (nonatomic, retain) Concept * parentConcept;
@property (nonatomic, retain) NSSet* connectedConcepts;
@property (nonatomic, retain) Document * document;

@end


@interface Concept (CoreDataGeneratedAccessors)
- (void)addConceptsObject:(Concept *)value;
- (void)removeConceptsObject:(Concept *)value;
- (void)addConcepts:(NSSet *)value;
- (void)removeConcepts:(NSSet *)value;

- (void)addConnectedConceptsObject:(Concept *)value;
- (void)removeConnectedConceptsObject:(Concept *)value;
- (void)addConnectedConcepts:(NSSet *)value;
- (void)removeConnectedConcepts:(NSSet *)value;

@end

