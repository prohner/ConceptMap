//
//  DocumentsViewController.h
//  ConceptMap
//
//  Created by Preston Rohner on 9/12/10.
//  Copyright 2010 Cool Tool Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataController.h"

@class ConceptMapViewController;

@interface DocumentsViewController : UITableViewController {
	ConceptMapViewController *conceptMapViewController;
}

@property (nonatomic, retain) ConceptMapViewController *conceptMapViewController;

@end
