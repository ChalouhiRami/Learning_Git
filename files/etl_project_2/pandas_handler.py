import pandas as pd


def return_dataframe_info(dataframe):
    info_dictionary = dict()
    info_dictionary['dataframe_length'] = len(dataframe)
    info_dictionary['total_count_of_table_id'] = int(dataframe.describe().iloc[0][0])
    return info_dictionary

def return_dataframe_subset_from_to_location(dataframe, from_loc, to_loc):
    return dataframe.loc[from_loc,to_loc]


def return_filtered_dataframe(dataframe, filter_field, filter_value):
    return dataframe[dataframe[filter_field.value] > filter_value]