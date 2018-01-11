--Name: Daniel Jordan
--Date: March 23, 2017
--Course: ITEC 320 Procedure Analysis and Design

--Purpose: This program implements a palindrome tester.
--Input: Text files and which is sorted into 3 categories
--       Palindrome as is:
--       Palindrome when converted to upper case:
--       Not a palindrome

--Sample input:
--   madAm i'm Adam!!
--     MadAm i'm AdaM!!
--     able was i ere I saw elba
--     able was I ere I saw elba
--     a man a plan a canal, panama
--        another random string for testing!
--
--   Madam I'm Adam!!
--        some random string
--            (***$$$!!!)
--        another random string

--Corresponding output:

--  Palindrome as is:
--     ""
--     ""
--     "MadAmimAdaM"
--     "ablewasIereIsawelba"
--     "amanaplanacanalpanama"
--     "madAmimAdam"
--
--  Palindrome when converted to upper case:
--     "MadamImAdam"
--     "ablewasiereIsawelba"
--
--  Not a palindrome:
--     "anotherrandomstring"
--     "anotherrandomstringfortesting"
--     "somerandomstring"

pragma Ada_2012;
with ada.text_io; use ada.text_io;
with Ada.Integer_Text_IO; use ada.Integer_Text_IO;
with ada.float_text_io; use ada.float_text_io;
with ada.Characters.Handling; use ada.Characters.Handling;
with ada.Containers.Generic_Array_Sort;

procedure do_pals  is

   --Record of lineInputs
   type lineInput is record
      individualLine: String(1 .. 61);
      lastPosition: Natural := 0;
   end record;

   --The constrained range for the number of lines the program takes
   subtype arrayOfRecordRange is Natural range 1 .. 101;

   --Array of lineInputs
   type lineInput_array is array (arrayOfRecordRange range <>) of lineInput;

   --Record of an array of Records
   type lineInput_GodRecord is record
      completeArray: lineInput_array(arrayOfRecordRange);
      numOfLineRecords: Natural := 0;
   end record;

   --Record for all the categorized Records
   type categorized_GodRecord is record
      palAsIs: lineInput_array(arrayOfRecordRange);
      palAsIsLastPosition: Natural := 0;
      palToUpper: lineInput_array(arrayOfRecordRange);
      palToUpperLastPosition: Natural := 0;
      notPal: lineInput_array(arrayOfRecordRange);
      notPalLastPosition: Natural := 0;
   end record;

   ----------------------------------------------------------
   -- Purpose: For alphabetizing the lines in the records
   -- Parameters: top, bottom: which are slices of the lines
   -- Precondition:
   -- Postcondition: Returns true if the top line slice is less than bottom
   ----------------------------------------------------------
   function lessThan (top, bottom: lineInput) return boolean is
     (top.individualLine(1..top.lastPosition) <
      (bottom.individualLine(1..bottom.lastPosition)));

   ----------------------------------------------------------
   -- Purpose: For chekcing if a string is a palindrome
   -- Parameters: str: which are the strings contained in the records
   -- Precondition:
   -- Postcondition: Returns true if all characters match, from beginning to end
   --                of the string
   ----------------------------------------------------------
   function isPalindrome (str: String) return boolean is

      forwardCounter: Natural := 0;
      output: Boolean := true;

   begin

      for i in reverse 1 .. str'last loop

         forwardCounter := forwardCounter + 1;
         if(str(forwardCounter) /= str(i)) then
            output := false;
         end if;

      end loop;

      return output;
   end isPalindrome;

   ----------------------------------------------------------
   -- Purpose: For categorizing the complete record into the categorized record
   -- Parameters: completeRecord: which is a slice of the array of records
   --           : categoriedRecord: which will be the complete categorized array
   -- Precondition:
   -- Postcondition: Returns back the filled categorized_GodRecord so it can be
   --                printed
   ----------------------------------------------------------
   procedure categorizeRecords(completeRecord: in lineInput_array;
                               categorizedRecord: out categorized_GodRecord) is

      palArrIndex: Natural := 0;
      upPalArrIndex: Natural := 0;
      notPalArrIndex: Natural := 0;

   begin

      --Looping thru the slice
      for i in 1 .. completeRecord'last loop

         --Testing for if the string is a pal as is
         if(isPalindrome(completeRecord(i).individualLine(
                                    1 .. completeRecord(i).lastPosition))) then
               --Incrementing the pal as is index
               palArrIndex := palArrIndex + 1;
            --setting the categorized God record from the complete
            categorizedRecord.palAsIs(palArrIndex).individualLine(
                                       1 .. completeRecord(i).lastPosition) :=
              completeRecord(i).individualLine(
                                       1 .. completeRecord(i).lastPosition);
            --Saving the length of the stored string into the new category
            categorizedRecord.palAsIs(palArrIndex).lastPosition :=
              completeRecord(i).lastPosition;


            --Testing for if the string is a pal to upper case
         elsif isPalindrome(To_Upper(completeRecord(i).individualLine(
                            1 .. completeRecord(i).lastPosition))) then
            --Increment the pal to upper index
            upPalArrIndex := upPalArrIndex + 1;
            --setting the categorized God record from the complete
            categorizedRecord.palToUpper(upPalArrIndex).individualLine(
                                       1 .. completeRecord(i).lastPosition) :=
              completeRecord(i).individualLine(
                                               1 .. completeRecord(i).lastPosition);
            --Saving the length of the stored string into the new category
            categorizedRecord.palToUpper(upPalArrIndex).lastPosition :=
              completeRecord(i).lastPosition;

         else
              --Increment the not pal index
            notPalArrIndex := notPalArrIndex + 1;
            --setting the categorized God record from the complete
            categorizedRecord.notPal(notPalArrIndex).individualLine(
                                       1 .. completeRecord(i).lastPosition) :=
            completeRecord(i).individualLine(1 .. completeRecord(i).lastPosition);
              --Saving the length of the stored string into the new category
            categorizedRecord.notPal(notPalArrIndex).lastPosition :=
              completeRecord(i).lastPosition;

         end if;


      end loop;

      --Setting the total line count for each categorized records
      categorizedRecord.palAsIsLastPosition := palArrIndex;
      categorizedRecord.palToUpperLastPosition := upPalArrIndex;
      categorizedRecord.notPalLastPosition := notPalArrIndex;

   end categorizeRecords;


   ----------------------------------------------------------
   -- Purpose: For printing each category from the completeRecord
   -- Parameters: completeRecord: which is the completely categorized and
   --             alphabetized record.
   -- Precondition:
   -- Postcondition:
   ----------------------------------------------------------
   procedure putStrings (completeRecord: in lineInput_array) is

      finalCategorizedRecord: categorized_GodRecord;

   begin

      categorizeRecords(completeRecord, finalCategorizedRecord);

      New_Line;
      Put_Line("Palindrome as is: ");

          for i in 1 .. finalCategorizedRecord.palAsIsLastPosition loop

             Set_Col(4);
             Put("""");
             Put(finalCategorizedRecord.palAsIs(i).individualLine(
                      1 .. finalCategorizedRecord.palAsIs(i).lastPosition));
             Put("""");
             New_Line;
          end loop;

      New_Line;
      Put_Line("Palindrome when converted to upper case: ");

           for j in 1 .. finalCategorizedRecord.palToUpperLastPosition loop

             Set_Col(4);
             Put("""");
             Put(finalCategorizedRecord.palToUpper(j).individualLine(
                      1 .. finalCategorizedRecord.palToUpper(j).lastPosition));
             Put("""");
             New_Line;
           end loop;

      New_Line;
      Put_Line("Not a palindrome: ");

            for k in 1 .. finalCategorizedRecord.notPalLastPosition loop

             Set_Col(4);
             Put("""");
             Put(finalCategorizedRecord.notPal(k).individualLine(
                      1 .. finalCategorizedRecord.notPal(k).lastPosition));
             Put("""");
             New_Line;
            end loop;

   end putStrings;

     ----------------------------------------------------------
     -- Purpose: A generic array sort for alphabetizing the lines in the records
     -- Parameters:
     -- Precondition:
     -- Postcondition: Returns the alphabetized records
     ----------------------------------------------------------
     procedure alphabetizeStrings is new ada.Containers.Generic_Array_Sort(

          Index_Type   => arrayOfRecordRange,
          Element_Type => lineInput,
          Array_Type   => lineInput_array,
          "<"          => lessThan);

   ----------------------------------------------------------
   -- Purpose: For getting then stripping the lines in the records of special
   --          characters
   -- Parameters: strippedLines: which will return the stripped lines to the
   --             main procedure
   -- Precondition:
   -- Postcondition:
   ----------------------------------------------------------
   procedure getAndStripStrings (strippedLines: out lineInput_GodRecord) is

      --"Duplicate" record to store the stripped strings
      non_strippedLines: lineInput_GodRecord;

      --Index for the stripped array of records
      strippedArrayIndex: Natural := 1;

      --Index for the stripped line index
      strippedLineCharIndex: Natural := 0;

      --used as an index for the Get_Line method
      non_strippedArrIndex1: Natural := 0;

      --used as an index for the for loops
      non_strippedArrIndex2: Natural := 1;

   begin

      --Start drilling down thru the God record into the lineInput record lines
      while not End_Of_File loop

         --Incrementing the index of the "original" record
         --to fill up the record's values
         non_strippedArrIndex1 := non_strippedArrIndex1 + 1;

         Get_Line(Item => non_strippedLines.completeArray(
                  non_strippedArrIndex1).individualLine,
                  Last => non_strippedLines.completeArray(
                    non_strippedArrIndex1).lastPosition);

         --Exception handling
         declare
         begin
         --Checking for too many lines
         if(non_strippedArrIndex1 > 100) then
            Put_Line("Too much input");
            raise Constraint_Error;
            --Chekcing if the strings are greater than 60
            elsif(non_strippedLines.completeArray(
                                  non_strippedArrIndex1).lastPosition > 60) then
            Put_Line("Line too long");
            raise Constraint_Error;

         end if;
         end;

         --for loops to strip the lines of special characters
         for i in 1 .. non_strippedLines.completeArray(
                                        non_strippedArrIndex2).lastPosition loop

            --Checking for alphabetical characters
            if (non_strippedLines.completeArray(
                                     non_strippedArrIndex2).individualLine(i) in
                                                   'a' .. 'z' | 'A' .. 'Z') then

               --Incrementing the character index of the "stripped" lines
               strippedLineCharIndex := strippedLineCharIndex + 1;

               --"Saving" the "stripped" characters to the duplicate record
               strippedLines.completeArray(strippedArrayIndex).individualLine(
                                                       strippedLineCharIndex) :=
                 non_strippedLines.completeArray(
                                       non_strippedArrIndex2).individualLine(i);

               --Setting the value of lastPosition of the current stripped record
               strippedLines.completeArray(strippedArrayIndex).lastPosition :=
                                       strippedLineCharIndex;

            end if;

         end loop;

         --Incrementing the array index of the "stripped" array of records
         strippedArrayIndex := strippedArrayIndex + 1;
         --Incrementing the array index of the "non_stripped" array of records
         non_strippedArrIndex2 := non_strippedArrIndex2 + 1;

         --Setting the "stripped" indexes back to 0 before
         --going to the next individual line
         strippedLineCharIndex := 0;

      end loop;

      strippedLines.numOfLineRecords := non_strippedArrIndex1;

   end getAndStripStrings;

   --------------------------------------------------------------------------------

   --parameter that's coming back from getAndStripStrings
   strippedLines: lineInput_GodRecord;

begin

   getAndStripStrings(strippedLines);

   alphabetizeStrings(strippedLines.completeArray(
                      1 .. strippedLines.numOfLineRecords));

   putStrings(strippedLines.completeArray(
              1 .. strippedLines.numOfLineRecords));

exception

   when Data_Error => Put_Line("Invalid values input");
   when End_Error => Put_Line("Unexpected end of file reached");
   when Constraint_Error => Put_Line("Range exceeded");
   when Others => Put_Line("SOMETHING REALLY BAD HAPPENED!!! @ itec2");

end do_pals;
