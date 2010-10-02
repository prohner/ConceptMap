//
//  ActionsViewController.m
//  ConceptMap
//
//  Created by Preston Rohner on 9/29/10.
//  Copyright 2010 Cool Tool Apps. All rights reserved.
//

#import "ActionsViewController.h"
#import "Utility.h"
#import "DataController.h"

#define ROW_EMAIL_AS_LIST		1

@implementation ActionsViewController


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];

	self.title = @"Actions";
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	self.contentSizeForViewInPopover = CGSizeMake(320.0, 210.0);
}


/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Override to allow orientations other than the default portrait orientation.
    return YES;
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 2;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
	switch (indexPath.row) {
		case 0:
			cell.textLabel.text = @"Email as Image";
			break;
		case ROW_EMAIL_AS_LIST:
			cell.textLabel.text = @"Email as List";
			break;
		default:
			break;
	}
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	/*
	 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:detailViewController animated:YES];
	 [detailViewController release];
	 */
	switch (indexPath.row) {
		case ROW_EMAIL_AS_LIST:
			[self emailList];

			break;
		default:
			break;
	}
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

#pragma mark Email Methods
- (void)emailList {
	//	NSLog(@"Need to send email");
	NSMutableString *messageBody = [[NSMutableString alloc] initWithString:@"<table border=1>"];
	for (Concept *concept in [DATABASE currentDocument].concepts) {
		if (concept.parentConcept == nil) {
			[messageBody appendString:[self stringForConcept:concept withIndent:@""]];
			[messageBody appendString:[self concepts:concept.concepts indented:@"&nbsp;"]];
		}
	}

	[messageBody appendString:@"</table>"];
	
	MFMailComposeViewController* composerController = [[MFMailComposeViewController alloc] init];
	composerController.mailComposeDelegate = self;
	NSString *subject = [[NSString alloc] initWithFormat:@"%@", [DATABASE currentDocument].title];
	NSString *body = [[NSString alloc] initWithFormat:@"<div></div>"
					  "<div style=\"\">Concept Map: </div>"
					  "<div>%@</div>"
					  "<div><p>Created using "
					  "<span style=\"background-color:#ffff00\"><a href=\"http://cooltoolapps.appspot.com/what-in-the-world-learn\">%@</a></span>"
					  " on my %@.</p></div>", 
					  messageBody,
					  APPLICATION_NAME,
					  [[UIDevice currentDevice] model]];
	[composerController setSubject:subject];
	
	[composerController setMessageBody:body isHTML:YES]; 
	[self presentModalViewController:composerController animated:YES];
	[composerController release];
	[subject release];
	[body release];
	[messageBody release];
}

- (NSString *)concepts:(NSSet *)concepts indented:(NSString *)indent {
	NSMutableString *s = [[NSMutableString alloc] init];
	NSString *nextIndent = [[NSString alloc] initWithFormat:@"%@&nbsp;", indent];
	for (Concept *concept in concepts) {
		[s appendString:[self stringForConcept:concept withIndent:indent]];
		[s appendString:[self concepts:concept.concepts indented:nextIndent]];
	}
	return s;
}

- (NSString *)stringForConcept:(Concept *)concept withIndent:(NSString *)indent {
	return [[NSString alloc] initWithFormat:@"<tr><td>%@ <b>%@</b> -- %@</td></tr>", indent, concept.title, concept.bodyDisplayString];
	
}

- (void)mailComposeController:(MFMailComposeViewController*)controller  
          didFinishWithResult:(MFMailComposeResult)result 
                        error:(NSError*)error {
	[self dismissModalViewControllerAnimated:YES];
}


@end

