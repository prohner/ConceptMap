//
//  Application.h
//  ConceptMap
//
//  Created by Preston Rohner on 9/28/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Document;

@interface Application :  NSManagedObject  
{
}

@property (nonatomic, retain) NSSet* documents;
@property (nonatomic, retain) Document * currentDocument;

@end


@interface Application (CoreDataGeneratedAccessors)
- (void)addDocumentsObject:(Document *)value;
- (void)removeDocumentsObject:(Document *)value;
- (void)addDocuments:(NSSet *)value;
- (void)removeDocuments:(NSSet *)value;

@end

