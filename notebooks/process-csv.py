# %%
import pandas as pd

# %%
# Load CSV into a DataFrame
df = pd.read_csv('../data/customers.csv')

# %%
# Split the DataFrame into two DataFrames
df_first = df.head(100)   # First 100 records
df_rest = df.tail(len(df) - 100)  # Remaining records
del df_first['Prefix']


# %%
df_first.to_csv('../data/customers-1.csv', header=True, index=False)
df_rest.to_csv('../data/customers-2.csv', header=True, index=False)

# %%
