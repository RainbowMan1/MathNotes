//
//  NotesDashboardViewController.m
//  MathNotes
//
//  Created by Nikesh Subedi on 7/13/20.
//  Copyright © 2020 Nikesh Subedi. All rights reserved.
//

#import "NotesDashboardViewController.h"
#import "Parse/Parse.h"
#import "SharedNote.h"
#import "NoteCell.h"
#import "SceneDelegate.h"
#import "NotesEditorViewController.h"
#import "FBShareViewController.h"
#import "SharedUserViewController.h"
#import <PFFacebookUtils.h>



@interface NotesDashboardViewController ()<UITableViewDataSource, UITableViewDelegate, NoteCellDelegate, FBShareDelegate, SharedUserViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *notes;
@property (strong, nonatomic) NSMutableArray *currentNotes;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UITextField *searchField;
@property (strong, nonatomic) Note *noteToBeShared;
@end

@implementation NotesDashboardViewController


#pragma mark - View Config
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.tableView.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"texture"]];
    self.view.backgroundColor =[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"texture"]];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [self fetchNotes];
    
    self.refreshControl =[[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchNotes) forControlEvents:UIControlEventValueChanged];
    
    [self.tableView addSubview:self.refreshControl];
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.tableView addGestureRecognizer:gestureRecognizer];
    gestureRecognizer.cancelsTouchesInView = NO;
    
    [self.searchField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [self.tabBarController.tabBar setHidden:NO];
    self.tabBarController.tabBar.tintColor = [UIColor systemBlueColor];
    NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
    [self.tableView deselectRowAtIndexPath:selectedIndexPath animated:YES];
    if (self.isViewLoaded){
        [self fetchNotes];
    }
}

#pragma mark - fetch from database

- (void)fetchNotes {
    PFQuery *notesQuery = [PFQuery queryWithClassName:@"Notes"];
    [notesQuery includeKey:@"author"];
    [notesQuery whereKey:@"author" equalTo:[PFUser currentUser]];
        // fetch data asynchronously
        [notesQuery findObjectsInBackgroundWithBlock:^(NSArray *notesArray, NSError *error) {
            if (notesArray != nil) {
                self.notes = [notesArray mutableCopy];
                PFQuery *sharedNotesQuery = [PFQuery queryWithClassName:@"SharedNotes"];
                [sharedNotesQuery includeKey:@"sharedNote"];
                [sharedNotesQuery includeKey:@"sharedNote.author"];
                [sharedNotesQuery includeKey:@"sharedUser"];
                [sharedNotesQuery whereKey:@"sharedUser" equalTo:[PFUser currentUser]];
                [sharedNotesQuery findObjectsInBackgroundWithBlock:^(NSArray *sharedNotesArray, NSError *error) {
                if (sharedNotesArray != nil) {
                    for (SharedNote *sharedNote in sharedNotesArray){
                        [self.notes addObject:sharedNote.sharedNote];
                    }
                }
                    [self.notes sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"updatedAt" ascending:NO]]];
                    self.currentNotes = [[NSMutableArray alloc] initWithArray:self.notes];
                    [self textFieldDidChange:self.searchField];
                    [self.refreshControl endRefreshing];
                }];
            } else {
            }
        }];
    
}

#pragma mark - Search bar

-(void)textFieldDidChange :(UITextField *) textField{
    [self.currentNotes removeAllObjects];
    if ([self.searchField.text isEqualToString:@""]) {
        self.currentNotes = [[NSMutableArray alloc]initWithArray:self.notes];
    }
    for (Note *note in self.notes){
        if ([[note.noteName lowercaseString] rangeOfString:[self.searchField.text lowercaseString]].location != NSNotFound) {
            [self.currentNotes addObject:note];
        }
    }
    [self.tableView reloadData];
}
- (void)hideKeyboard {
    [self.searchField endEditing:YES];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.currentNotes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NoteCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NoteCell" forIndexPath:indexPath];
    cell.delegate = self;
    cell.note = self.currentNotes[indexPath.row];
    
    return cell;
}
#pragma mark - Table view delete

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Are you Sure?"
                                                                           message:@"Do you want to delete the note"
                                                                    preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"Yes"
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * _Nonnull action) {
                [self.tableView beginUpdates];
                [self.notes removeObject:self.currentNotes[indexPath.row]];
                [Note deleteNote:self.currentNotes[indexPath.row] withCompletion:nil];
                [self.currentNotes removeObjectAtIndex:indexPath.row];
                
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

#pragma mark - NoteCell Delegate
- (void) didTapRename:(Note *)note withCompletion:(PFBooleanResultBlock _Nullable)completion{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle: [@"Rename " stringByAppendingString:note.noteName]
                                                                                  message: @"Type new name for the note"
                                                                              preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"name";
        textField.borderStyle = UITextBorderStyleRoundedRect;
        textField.text = note.noteName;
        textField.clearsOnInsertion =YES;
    }];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSArray * textfields = alertController.textFields;
        UITextField * namefield = textfields[0];
        NSLog(@"%@",namefield.text);
        note.noteName = namefield.text;
        [Note updateNote:note withCompletion:completion];
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)shareAlertForNote:(Note *)note withCompletion: (PFBooleanResultBlock  _Nullable)completion{
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
        [SharedNote shareNote:note withUsername:namefield.text withCompletion:completion];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void) didTapShare:(Note *)note withCompletion: (PFBooleanResultBlock  _Nullable)completion{
    if (![PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]){
        [self shareAlertForNote:note withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
            if (succeeded){
                [self fetchNotes];
            }
        }];
    }
    else{
        self.noteToBeShared = note;
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        FBShareViewController *shareController = [storyboard instantiateViewControllerWithIdentifier:@"ShareViewController"];
        shareController.delegate = self;
        shareController.titleLabel.text = @"Share Note";
        [self presentViewController:shareController animated:YES completion:nil];
    }
}

- (void)presentSharedUserControllerWithNote:(Note *)note{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SharedUserViewController *shareController = [storyboard instantiateViewControllerWithIdentifier:@"SharedUserViewController"];
    shareController.sharedObject = note;
    shareController.delegate = self; 
    [self presentViewController:shareController animated:YES completion:nil];
}

#pragma mark - Share Delegate

- (void)didShareToFBID:(NSString *)FBID{
    [SharedNote shareNote:self.noteToBeShared withFBID:FBID withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded){
            [self fetchNotes];
        }
    }];
}

- (void)didShareToUsername{
    [self shareAlertForNote:self.noteToBeShared withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded){
            [self fetchNotes];
        }
    }];
}

#pragma mark - ShareViewControllerDelegate

- (void)updateTable{
    [self fetchNotes];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"NewNote"]) {
        NotesEditorViewController *noteEditor = [segue destinationViewController];
        noteEditor.note = [Note getNewNote] ;
    }
    else if ([segue.identifier isEqualToString:@"EditNote"]) {
        NotesEditorViewController *noteEditor = [segue destinationViewController];
        NoteCell *selectedcell = (NoteCell*) sender;
        //NSLog(@"%@",selectedcell.note.htmlText);
        noteEditor.note = selectedcell.note;
    }
}

@end
