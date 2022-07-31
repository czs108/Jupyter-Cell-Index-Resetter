# Jupyter Cell Index Resetter

![PowerShell](badges/PowerShell.svg)
![License](badges/License-MIT.svg)

## Introduction

![Cover](Cover.png)

This script is used to reset a [***Jupyter***](https://jupyter.org) notebook's execution cell indexes, making them increase from 1.

## Usage

You need to specify a *Jupyter* file and an *output name*.

```console
PS> .\Reset-JupyterCellIndex.ps1 -InputPath origin.ipynb -OutputPath new.ipynb
```

## Warning

Variable values in cells might be different according to execution order. Users should make sure variables are correct by themselves.

```console
In  [2]: a = 1
```

```console
In  [1]: a = 0
```

```console
In  [3]: a
Out [3]: 1
```

For example, the above cells will become the following content after resetting:

```console
In  [1]: a = 1
```

```console
In  [2]: a = 0
```

```console
In  [3]: a
Out [3]: 1
```

The output of variable `a` is incorrect according to the new execution order.

## License

Distributed under the *MIT License*. See `LICENSE` for more information.

## Contact

***GitHub***: https://github.com/czs108

***E-Mail***: chenzs108@outlook.com

***WeChat***: chenzs108