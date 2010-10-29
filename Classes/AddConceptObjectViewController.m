//
//  AddConceptObjectViewController.m
//  ConceptMap
//
//  Created by Preston Rohner on 10/20/10.
//  Copyright 2010 Cool Tool Apps. All rights reserved.
//

#import "AddConceptObjectViewController.h"
#import "Utility.h"
#import "ConceptMapViewController.h"

@implementation AddConceptObjectViewController

@synthesize conceptMapViewController;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	self.title = NSLocalizedString(@"Add Template", @"");
	self.contentSizeForViewInPopover = CGSizeMake(320.0, 500.0);
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
    return AddConceptTemplateCategoriesMAX;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	switch (section) {
		case AddConceptTemplateCategoryGeneral:
			return NSLocalizedString(@"General Items", @"");
			break;
		case AddConceptTemplateCategoryComputer:
			return NSLocalizedString(@"Computers", @"");
			break;
		case AddConceptTemplateCategoryHome:
			return NSLocalizedString(@"Home", @"");
			break;
	}
	return @"What's this?";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	switch (section) {
		case AddConceptTemplateCategoryGeneral:
			return AddTemplatesGeneralMAX;
			break;
		case AddConceptTemplateCategoryComputer:
			return AddTemplatesComputerMAX;
			break;
		case AddConceptTemplateCategoryHome:
			return AddTemplatesHomeMAX;
		default:
			break;
	}
    return 0;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
	switch (indexPath.section) {
		case AddConceptTemplateCategoryGeneral:
			switch (indexPath.row) {
				case AddTemplatesGeneralSquare:
					cell.textLabel.text = NSLocalizedString(@"Square", "");
					break;
				case AddTemplatesGeneralVerticalRectangle:
					cell.textLabel.text = NSLocalizedString(@"Vertical Rectangle", "");
					break;
				case AddTemplatesGeneralHorizontalRectangle:
					cell.textLabel.text = NSLocalizedString(@"Horizontal Rectangle", "");
					break;
				default:
					break;
			}
			break;
		case AddConceptTemplateCategoryComputer:
			switch (indexPath.row) {
				case AddTemplatesComputerServer:
					cell.textLabel.text = NSLocalizedString(@"Server", "");
					break;
				case AddTemplatesComputerDesktop:
					cell.textLabel.text = NSLocalizedString(@"Desktop", "");
					break;
				case AddTemplatesComputerSwitch:
					cell.textLabel.text = NSLocalizedString(@"Switch", "");
					break;
				case AddTemplatesComputerRouter:
					cell.textLabel.text = NSLocalizedString(@"Router", "");
					break;
				case AddTemplatesComputerFirewall:
					cell.textLabel.text = NSLocalizedString(@"Firewall", "");
					break;
				case AddTemplatesComputerConcentrator:
					cell.textLabel.text = NSLocalizedString(@"Concentrator", "");
					break;
				default:
					break;
			}
			break;
		case AddConceptTemplateCategoryHome:
			switch (indexPath.row) {
				case AddTemplatesHomeGarage:
					cell.textLabel.text = NSLocalizedString(@"Garage", "");
					break;
				default:
					break;
			}
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

	switch (indexPath.section) {
		case AddConceptTemplateCategoryGeneral:
			switch (indexPath.row) {
				case AddTemplatesGeneralSquare:
					[conceptMapViewController addSquare];
					break;
				case AddTemplatesGeneralVerticalRectangle:
					[conceptMapViewController addVerticalRectangle];
					break;
				case AddTemplatesGeneralHorizontalRectangle:
					[conceptMapViewController addHorizontalRectangle];
					break;
				default:
					break;
			}
			break;
		case AddConceptTemplateCategoryComputer:
			switch (indexPath.row) {
				case AddTemplatesComputerServer:
					[conceptMapViewController addComputerServer];
					break;
				case AddTemplatesComputerDesktop:
					[conceptMapViewController addComputerDesktop];
					break;
				case AddTemplatesComputerSwitch:
					FUNCTION_LOG(@"Switch");
					break;
				case AddTemplatesComputerRouter:
					FUNCTION_LOG(@"Router");
					break;
				case AddTemplatesComputerFirewall:
					FUNCTION_LOG(@"Firewall");
					break;
				case AddTemplatesComputerConcentrator:
					FUNCTION_LOG(@"Concentrator");
					break;
				default:
					break;
			}
			break;
		case AddConceptTemplateCategoryHome:
			switch (indexPath.row) {
				case AddTemplatesHomeGarage:
					FUNCTION_LOG(@"Garage");
					break;
				default:
					break;
			}
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


@end

