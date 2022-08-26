import React from "react";
import { Button as AriakitButton } from "ariakit/button";
import styled, { css, system, th } from "@xstyled/styled-components";
import { getStatusColor } from "../containers/Status";

const InnerButton = styled.buttonBox(({ $tint = "primary" }) => {
  const bgColor = th.color(`${$tint}-800-a80`);
  const hoverBgColor = th.color(`${$tint}-700-a80`);
  const borderColor = th.color(`${$tint}-400-a60`);

  return css`
    display: flex;
    align-items: center;
    justify-content: center;
    white-space: nowrap;
    border-radius: md;
    cursor: default;
    border: 1;
    border-color: ${borderColor};
    padding: 3 4;
    color: white;
    transition: default;
    transition-duration: 300ms;
    font-weight: 600;
    line-height: 1;
    text-decoration: none;
    gap: 1;

    background-color: ${bgColor};

    &:hover:not(:disabled),
    &:active:not(:disabled) {
      background-color: ${hoverBgColor};
    }

    &:focus-visible {
      ${system.apply({ ring: 2, ringColor: "primary-300-a50" })}
    }

    &:disabled {
      cursor: default;
      opacity: 0.38;
    }
  `;
});

export const Button = React.forwardRef(
  ({ variant = "primary", children, as, ...props }, ref) => {
    const baseColor = getStatusColor(variant);
    return (
      <AriakitButton ref={ref} $tint={baseColor} {...props}>
        {(buttonProps) => (
          <InnerButton {...buttonProps} as={as}>
            {children}
          </InnerButton>
        )}
      </AriakitButton>
    );
  }
);
