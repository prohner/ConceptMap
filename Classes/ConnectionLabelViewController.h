//
//  ConceptObjectTitleViewController.h
//  ConceptMap
//
//  Created by Preston Rohner on 9/19/10.
//  Copyright 2010 Cool Tool Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utility.h"

@class ConnectedConcept;

@interface ConnectionLabelViewController : UIViewController {
	UITextField *objectTitle;
	ConnectedConcept *connectedConcept;
}

@property (nonatomic, retain) IBOutlet UITextField *objectTitle;
@property (nonatomic, retain) ConnectedConcept *connectedConcept;

- (IBAction)titleTextHasChanged:(id)sender;

@end
