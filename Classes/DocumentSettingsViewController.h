//
//  DocumentSettingsViewController.h
//  ConceptMap
//
//  Created by Preston Rohner on 9/29/10.
//  Copyright 2010 Cool Tool Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ConceptMapViewController;

@interface DocumentSettingsViewController : UITableViewController {
	ConceptMapViewController *conceptMapViewController;
}

@property (nonatomic, retain) ConceptMapViewController *conceptMapViewController;

- (UIImage *)imageForRow:(int)indexPathRow;

@end
