//
//  ConceptObjectTitleViewController.h
//  ConceptMap
//
//  Created by Preston Rohner on 9/19/10.
//  Copyright 2010 Cool Tool Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utility.h"

@interface ConceptObjectTitleViewController : UIViewController {
	UITextField *objectTitle;

}

@property (nonatomic, retain) IBOutlet UITextField *objectTitle;

- (IBAction)titleTextHasChanged:(id)sender;

@end
