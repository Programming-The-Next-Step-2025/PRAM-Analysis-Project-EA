# PRAM.Analysis.Project.EA

The goal of PRAM.Analysis.Project.EA is to be used alongside CIETmap to improve an existing network analysis workflow. It will form the base of an update to CIETmap in the future. It is a Shiny app that aids with the standardization and categorization process.

to learn more about Fuzzy cognitive map analysis please read:

**Four analysis moments for fuzzy cognitive mapping in participatory research** *Journal of Public Health Research* DOI: [10.1080/16549716.2024.2430024](https://www.tandfonline.com/doi/full/10.1080/16549716.2024.2430024?src=#abstract)

## Installation

You can install PRAM.Analysis.Project.EA from [GitHub](https://github.com/) with:

``` r
# Install devtools if not already installed
install.packages("devtools")

# Install PRAMAnalysis from GitHub
devtools::install_github("Programming-The-Next-Step-2025/PRAM-Analysis-Project-EA")
```

# Usage

After installing the package you can begin using it to launch the Shiny app:

```{r}
library(PRAMAnalysis)
#launch the Shiny app 
run_PRAM_table()
```

## Start up

This is what the user interface(UI) will look like on start up:

![](Screenshots/UI%20startup.png)

From here you can click the button to browse your computer for any CSV or Excel file using the upload button.

## Editing the Table

You can use the example to preview what the table will look like. for this image I have

![](Screenshots/Example%20Load.png)

As you can see the table has 4 new columns where you can add the names and switch the edges.

Once you've given each Node a new Label you'll see a visualization of how many unique standard names you've made!![](Screenshots/example%20network%20vis+category.png)

then you can group the standard names together and assign new category labels taking this simple example network from 10 nodes down to 2 categories!

### Behind the Scenes (Functions)

#### `parse_uploaded_file()`

**Purpose**: This function handles data file uploads in the Shiny app. It supports .csv and Excel files (.xls, .xlsx), reads them into R as a data.frame, and ensures consistent parsing regardless of format.

**How it works**:

-   Accepts a Shiny file input (input\$file) or a string path.

-   Detects the file extension using tools::file_ext.

-   Uses readxl::read_excel() to parse .xls or .xlsx, and readr::read_csv() to parse .csv.

-   If the file extension is unsupported, throws an informative error.

-   Returns a data.frame ready for further processing.

#### `prepare_shiny_data()`

**Purpose**: This function formats the uploaded data for interactive use in the Shiny interface. It ensures required columns exist, cleans column names, and appends fields used in UI inputs.

**How it works**:

-   Cleans column names by trimming whitespace and replacing spaces with underscores.

-   Checks for required columns and adds them if missing:

    -   Standared_Node_names: a character column for standardized naming.

    -   Switch: a logical column (TRUE/FALSE) used as a checkbox toggle.

    -   Categories: a character column for user-defined categories (used in dropdown/autocomplete).

    -   Switch_Category: a logical column (TRUE/FALSE) toggle related to category use.

-   Returns the modified data.frame with all necessary columns.

#### `update_choices(state, df)`

**Purpose:**\
Updates the available dropdown/autocomplete options (`Standared_Node_names`, `Categories`) based on user input and changes in the handsontable.

**How it works:**

-   Accepts the `reactiveValues` object (`state`) and a data frame (`df`).

-   Scans the columns `Standared_Node_names` and `Categories` for new unique values.

-   Adds those values to `state$label_choices` and `state$category_choices`, respectively.

-   Uses `get_unique_choices()` to trim whitespace and remove blanks.

#### `get_unique_choices(x)`

**Purpose:** Sanitizes dropdown/autocomplete options.

**How it works:** - Accepts a vector x.

-   Trims leading/trailing whitespace and removes "" (blank) entries.

-   Returns sorted, deduplicated values.
