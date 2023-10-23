import pandas as pd


def remove_duplicates(df, subset=None):

    return df.drop_duplicates(subset=subset, keep='first')

def remove_nulls(df, columns=None):

    if columns:
        return df.dropna(subset=columns)
    else:
        return df.dropna()

def custom_transformations(df):
    df['new_column'] = df['existing_column'] * 2
    return df

