#!/bin/bash

if waybarctl get-class 2>/dev/null | grep -q "full"; then
    waybarctl remove-class "full"
    waybarctl add-class "pill"
else
    waybarctl remove-class "pill"
    waybarctl add-class "full"
fi