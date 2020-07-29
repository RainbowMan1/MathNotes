//
//  EquationSnipDashboardViewController.m
//  MathNotes
//
//  Created by Nikesh Subedi on 7/13/20.
//  Copyright © 2020 Nikesh Subedi. All rights reserved.
//

#import "EquationSnipDashboardViewController.h"
#import "EquationSnip.h"
#import "SharedEquationSnip.h"
#import "EquationSnipCell.h"
#import "EquationSnipsDetailViewController.h"

@interface EquationSnipDashboardViewController ()<UITableViewDelegate, UITableViewDataSource,EquationSnipCellDelegate>
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
    [self.equationSnips removeAllObjects];
    PFQuery *equationSnipsQuery = [PFQuery queryWithClassName:@"EquationSnips"];
    [equationSnipsQuery includeKey:@"author"];
    [equationSnipsQuery whereKey:@"author" equalTo:[PFUser currentUser]];
        // fetch data asynchronously
        [equationSnipsQuery findObjectsInBackgroundWithBlock:^(NSArray *equationSnipsArray, NSError *error) {
            if (equationSnipsArray != nil) {
                self.equationSnips = [equationSnipsArray mutableCopy];
                PFQuery *sharedEquationSnipsQuery = [PFQuery queryWithClassName:@"SharedEquationSnips"];
                [sharedEquationSnipsQuery includeKey:@"sharedEquationSnip"];
                [sharedEquationSnipsQuery includeKey:@"sharedEquationSnip.author"];
                [sharedEquationSnipsQuery includeKey:@"sharedUser"];
                [sharedEquationSnipsQuery whereKey:@"sharedUser" equalTo:[PFUser currentUser]];
                [sharedEquationSnipsQuery findObjectsInBackgroundWithBlock:^(NSArray *sharedEquationSnipsArray, NSError *error) {
                if (sharedEquationSnipsArray != nil) {
                    for (SharedEquationSnip *sharedEquationSnip in sharedEquationSnipsArray){
                        [self.equationSnips addObject:sharedEquationSnip.sharedEquationSnip];
                    }
                }
                    [self.equationSnips sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"updatedAt" ascending:NO]]];
                    self.currentEquationSnips = [[NSMutableArray alloc] initWithArray:self.equationSnips];
                    [self textFieldDidChange:self.searchField];
                    [self.refreshControl endRefreshing];
                }];
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
    cell.delegate = self;
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
                [EquationSnip deleteEquationSnip:self.currentEquationSnips[indexPath.row] withCompletion:nil];
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
#pragma mark - EquationSnipCell delegate
-(void) didTapRename:(EquationSnip *)equationSnip withCompletion:(PFBooleanResultBlock _Nullable)completion{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle: [@"Rename " stringByAppendingString:equationSnip.equationSnipName]
                                                                                  message: @"Type new name for the note"
                                                                              preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"name";
        textField.borderStyle = UITextBorderStyleRoundedRect;
        textField.text = equationSnip.equationSnipName;
        textField.clearsOnInsertion =YES;
    }];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSArray * textfields = alertController.textFields;
        UITextField * namefield = textfields[0];
        NSLog(@"%@",namefield.text);
        equationSnip.equationSnipName = namefield.text;
        [EquationSnip updateEquationSnip:equationSnip withCompletion:completion];
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}
- (void) didTapShare:(EquationSnip *)equationSnip withCompletion: (PFBooleanResultBlock  _Nullable)completion{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @"Share Note"
                                                                                  message: @"Type username of user to share note with them"
                                                                              preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"username";
        textField.borderStyle = UITextBorderStyleRoundedRect;
        textField.clearsOnInsertion =YES;
    }];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSArray * textfields = alertController.textFields;
        UITextField * namefield = textfields[0];
        [SharedEquationSnip shareEquationSnip:equationSnip withUsername:namefield.text withCompletion:completion];
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
    
    
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
