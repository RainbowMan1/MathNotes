//
//  EquationSnipDashboardViewController.m
//  MathNotes
//
//  Created by Nikesh Subedi on 7/13/20.
//  Copyright © 2020 Nikesh Subedi. All rights reserved.
//

#import "EquationSnipDashboardViewController.h"
#import "EquationSnip.h"
#import "EquationSnipCell.h"
#import "EquationSnipsDetailViewController.h"

@interface EquationSnipDashboardViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIImagePickerController *imagePicker;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) NSMutableArray *equationSnips;
@property (weak, nonatomic) IBOutlet UITextField *searchField;
@property (strong, nonatomic) NSMutableArray *currentEquationSnips;
@end

@implementation EquationSnipDashboardViewController

#pragma mark - View Config
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    self.refreshControl =[[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchEquationSnips) forControlEvents:UIControlEventValueChanged];
    
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.tableView addSubview:self.refreshControl];
       NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
    [self.tableView deselectRowAtIndexPath:selectedIndexPath animated:YES];
    
    [self fetchEquationSnips];
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.tableView addGestureRecognizer:gestureRecognizer];
    gestureRecognizer.cancelsTouchesInView = NO;
    
    [self.searchField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

}

- (void)viewWillAppear:(BOOL)animated{
    [self.tabBarController.tabBar setHidden:NO];
}

#pragma mark - fetch from database
- (void)fetchEquationSnips{
    PFQuery *query = [PFQuery queryWithClassName:@"EquationSnips"];
       [query orderByDescending:@"updatedAt"];
       [query whereKey:@"author" equalTo:[PFUser currentUser]];
           // fetch data asynchronously
           [query findObjectsInBackgroundWithBlock:^(NSArray *equationsArray, NSError *error) {
               if (equationsArray != nil) {
                   self.equationSnips = [equationsArray mutableCopy];
                   self.currentEquationSnips = [equationsArray mutableCopy];
                   [self textFieldDidChange:self.searchField];
                   [self.tableView reloadData];
                   [self.refreshControl endRefreshing];
               } else {
               }
           }];
}



#pragma mark - Search bar

-(void)textFieldDidChange:(UITextField *) textField{
    [self.currentEquationSnips removeAllObjects];
    if ([self.searchField.text isEqualToString:@""]) {
        self.currentEquationSnips = [[NSMutableArray alloc]initWithArray:self.equationSnips];
    }
    else{
        for (EquationSnip *snip in self.equationSnips){
            if ([[snip.equationSnipName lowercaseString] rangeOfString:[self.searchField.text lowercaseString]].location != NSNotFound) {
                [self.currentEquationSnips addObject:snip];
            }
        }
    }
    [self.tableView reloadData];
}
- (void)hideKeyboard {
    [self.searchField endEditing:YES];
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.currentEquationSnips.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EquationSnipCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EquationSnipCell" forIndexPath:indexPath];
    cell.equationSnip = self.currentEquationSnips[indexPath.row];
    return cell;
}

#pragma mark - Table view delete

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Are you Sure?"
                                                                           message:@"Do you want to delete the equation snip"
                                                                    preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"Yes"
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * _Nonnull action) {
                [self.tableView beginUpdates];
                [self.equationSnips removeObject:self.currentEquationSnips[indexPath.row]];
                [self.currentEquationSnips[indexPath.row] deleteInBackground];
                [self.currentEquationSnips removeObjectAtIndex:indexPath.row];
                [self.tableView deleteRowsAtIndexPaths:[NSArray<NSIndexPath *> arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                [self.tableView endUpdates];
            }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"No"
          style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction * _Nonnull action) {}];
        
        [yesAction setValue:[UIColor redColor] forKey:@"titleTextColor"];
            
            [alert addAction:cancelAction];
        [alert addAction:yesAction];
            [self presentViewController:alert animated:YES completion:^{}];
        
    }
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"EquationDetail"]) {
        EquationSnipCell *selectedCell = (EquationSnipCell*) sender;
        EquationSnipsDetailViewController *destination = [segue destinationViewController];
        destination.equationSnip = selectedCell.equationSnip;
    }
}

@end
