//
//  ViewController.m
//  Deprocrastinator
//
//  Created by Mary Jenel Myers on 1/12/15.
//  Copyright (c) 2015 Mary Jenel Myers. All rights reserved.
//

#import "ViewController.h"
#import "Task.h"

@interface ViewController () <UITabBarDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, UIAlertViewDelegate, UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property NSMutableArray *listArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property BOOL isEditing;
@property NSArray *priorityColorsArray;
@property int swipeCount;
@property NSIndexPath *cellIndexPath;


@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // called when the app first opens. the very first method called. only called once.

    self.listArray = [[NSMutableArray alloc] init];
    self.isEditing = false;
    self.swipeCount = 0;
    self.priorityColorsArray = [NSArray arrayWithObjects:[UIColor greenColor],[UIColor yellowColor], [UIColor redColor], [UIColor blackColor], nil];
    self.cellIndexPath = [NSIndexPath new]; // reference the indexpath for a selected cell from anywhere in the code
    self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;


}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listArray.count; // returns the number of rows needed to display the amount of data you have
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID"]; //creates a reusable cell object with specified "CellID"
    Task *task = [self.listArray objectAtIndex:indexPath.row];
    cell.textLabel.text = task.taskName;
    cell.textLabel.textColor = task.taskColor;
//    cell.textLabel.text = [NSString stringWithFormat:@"%@", self.listArray[indexPath.row]]; // filling the reusable cell with strings from the array. pulling from the list array. but referencing from the indexPath's row. similar to a for loop.. its built in the method.
    return cell; //returning a copy of the reusable cell with data pulled from the list array at specified indexPath.row
}



-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath]; //creates a cell object based of the cell selected
   Task *task = [self.listArray objectAtIndex:indexPath.row]; //index path.row tells you what cell you clicked. this grabs the information inside the cell storing it in task.

    task.taskColor = [UIColor greenColor];//changes the selected cell back ground color to green
   [self.tableView reloadData]; /* reload data since you change the tables data.*/
 if (self.isEditing) {
    cell.editing = true;
  }

}

- (IBAction)swipeRightRecognizer:(UISwipeGestureRecognizer *)gesture
{
    CGPoint touchDownPoint = [gesture locationInView:self.tableView];
    NSIndexPath *swipedIndexPath = [self.tableView indexPathForRowAtPoint:touchDownPoint];
    Task *swipedCell  = [self.listArray objectAtIndex:swipedIndexPath.row];
    swipedCell.taskColor = self.priorityColorsArray[self.swipeCount];
    // instead of using the cell. used the area with the tasks. changes the color
    self.swipeCount++;
    if (self.swipeCount == 4) {
        self.swipeCount = 0;
    }
    [self.tableView reloadData];

}

- (IBAction)onAddButtonPressed:(UIButton *)sender
{

    Task *task = [[Task alloc]init];
    task.taskName = self.textField.text;
    task.taskColor = [UIColor blackColor];
    [self.listArray addObject:task];
    [self.tableView reloadData];
    [self.view endEditing:YES];
    self.textField.text = @"";

}
-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    NSString *item = [self.listArray objectAtIndex:sourceIndexPath.row];
    [self.listArray removeObject:item];
    [self.listArray insertObject:item atIndex:destinationIndexPath.row];

}

- (IBAction)onEditButtonPressed:(UIButton *)sender
{

    if ([sender.titleLabel.text  isEqual:@"Edit"]) {

        [sender setTitle:@"Done" forState:UIControlStateNormal]; //
        self.tableView.editing = true;
    }
    else{
        [sender setTitle:@"Edit" forState:UIControlStateNormal];
        self.tableView.editing = false;
    }
}



-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath

{
    self.cellIndexPath = indexPath;

    UIAlertView *alert = [[UIAlertView alloc] init]; // dont need an if statement for action mode delete button possibly assumes first button is an action button
    alert.title =@"Are you sure?";
    [alert addButtonWithTitle:@"Cancel"];
    [alert addButtonWithTitle:@"Delete"];
    alert.delegate = self;
    [alert show];


}



-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [self.listArray removeObjectAtIndex:self.tableView.indexPathForSelectedRow.row]; //deleting the object from listArray Strings
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject: self.cellIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView reloadData];
    }
}

@end
