// Copyright (C) 2023 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR BSD-3-Clause

.pragma library

function calculateExpression(expr) {
    try {
        expr = expr.replace(/×/g, "*").replace(/÷/g, "/").replace(/−/g, "-");
        let res = eval(expr);
        return res.toString();
    } catch(e) {
        return "Ошибка";
    }
}
