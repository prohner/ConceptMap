//
//  AddConceptObjectViewController.h
//  ConceptMap
//
//  Created by Preston Rohner on 10/20/10.
//  Copyright 2010 Cool Tool Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ConceptMapViewController;

@interface AddConceptObjectViewController : UITableViewController {
	ConceptMapViewController *conceptMapViewController;
}

@property (nonatomic, retain) ConceptMapViewController *conceptMapViewController;

@end
