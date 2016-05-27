# case study ----------------------------------------------------

input_data <- six_panels
levels(slot(input_data, "exper")) <- LETTERS[1L:3]
input_summary <- dpcr2df(input_data)[, c(1, 3L:5)]


