# User Feedback Integration Guide

## Overview

Wire user feedback mechanisms (ratings, thumbs up/down, comments) into Langfuse as scores on traces. Requires existing tracing infrastructure.

## Key Implementation Steps

### 1. Choose Feedback Pattern

Before coding, present 2–3 UX options matching the application's context. Common patterns include:
- Thumbs up/down for chat apps
- Star ratings for content generation
- "Was this helpful?" banners for search
- Free-text comments for complex outputs

### 2. Name Scores Appropriately

Name reflects the signal source, not what you hope it measures (e.g., `user-thumbs` not `response-quality`). Use lowercase with hyphens and maintain consistency throughout the application.

### 3. Implementation Approach

- **Server-side (implicit feedback):** Call `langfuse.create_score()` where events occur
- **Client-side (explicit feedback):** Use `LangfuseWeb` with the public key only, never exposing secrets in frontend code

### 4. Verification

Check the Scores tab in Langfuse traces to confirm proper score creation with correct names, values, and data types.

## Critical Security Note

Always use `LangfuseWeb` with public keys for frontend scoring — never expose secret keys in browser code.

## Docs

https://langfuse.com/docs/scores/overview
