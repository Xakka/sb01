import numpy as np
import pandas as pd


def ex01():
    df = pd.read_excel("transactions.xlsx", nrows=1000000)
    df = df.fillna("-")
    df = df.rename(columns={"term_id": "term_id_1"})
    df["amount"] = pd.to_numeric(df["amount"], errors="coerce")
    # Значение в строке 3867 битое "01.06.2029"
    # 4074 - "13.07.2022" дальше не проверял
    # Всего таких значений 61 шт из 1000000 записей
    print(f"Сумма значений столбца amount: {df['amount'].sum()}")
    print(f"Минимальное значение столбца amount: {df['amount'].min()}")
    print(f"Максимальное значение столбца amount: {df['amount'].max()}")
    print(
        f"Сумма значений больше 0 столбца amount: {df['amount'].where(df['amount'] > 0).sum()}"
    )
    df["tr_datetime"] = df["tr_datetime"].replace("^\\d* ", "", regex=True)
    df["tr_datetime"] = df["tr_datetime"].replace(
        to_replace=":60", value=":59", regex=True
    )
    df1 = df[df["mcc_code"] > 6000]
    df1 = df1[df1["tr_datetime"] > "10:00:00"]
    print(
        f"Сумма значений столбца amount (mcc_code > 6000 && tr_datetime > '10:00:00') : {df1['amount'].mean()}"
    )
    print(df[::-1])
    print(df[9::10])

    df1 = df.groupby("customer_id")["amount"].mean().reset_index()
    df1 = df1[df1["amount"] > 0]
    print(df1)
    df1["random"] = np.random.randint(0, 100, size=len(df1))
    print(df1[df1["customer_id"].astype(str).str.contains(r"(?=.*3)(?=.*6)(?=.*8)")])


def ex02():
    df = pd.read_excel("transactions.xlsx", nrows=1000000, index_col="customer_id")
    df["amount"] = pd.to_numeric(df["amount"], errors="coerce")
    df1 = df[df["amount"] == df["amount"].max()]
    customer_id = df1[:1].index[0]
    print(f"Клиент с максимальной суммой транзакции:\n{df1}")
    df1 = df[df["amount"].index == customer_id]
    df1 = df1["amount"].abs()
    print(df1.groupby(df1).count().sort_values(ascending=False).head(10))


def ex03():
    df1 = pd.read_excel("transactions.xlsx", nrows=1000000)
    df1["amount"] = pd.to_numeric(df1["amount"], errors="coerce")
    df2 = pd.read_csv("tr_mcc_codes.csv", sep=";")
    df3 = pd.read_csv("tr_types.csv", sep=";")
    df4 = pd.read_csv("gender_train.csv")
    result = pd.merge(df1, df2, on="mcc_code", how="inner")
    result = pd.merge(result, df3, on="tr_type", how="inner")
    result = pd.merge(result, df4, on="customer_id", how="left")
    result[["tr_day", "time"]] = result["tr_datetime"].str.split(expand=True)
    tmp = result.groupby("tr_day")["mcc_code"].nunique().reset_index()
    tmp = tmp[tmp["mcc_code"] > 75]
    result = result[result["tr_day"].isin(tmp["tr_day"])]
    result = (
        result.groupby(["mcc_code", "mcc_description", "gender"])
        .agg({"amount": ["median", "mean"]})
        .reset_index()
    )
    print(result)


if __name__ == "__main__":
    print("--------- Задание 1-----------")
    ex01()
    print("--------- Задание 2-----------")
    ex02()
    print("--------- Задание 3-----------")
    ex03()
